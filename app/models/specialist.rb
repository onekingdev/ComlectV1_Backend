# frozen_string_literal: true
class Specialist < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :skills
  has_many :work_experiences, dependent: :destroy
  has_many :education_histories, dependent: :delete_all
  has_many :favorites, as: :owner, dependent: :destroy
  has_many :favorited_by, as: :favorited, dependent: :destroy, class_name: 'Favorite'
  has_many :favorited_projects, class_name: 'Project', through: :favorites, source: :favorited, source_type: 'Project'
  has_many :projects
  has_many :job_applications, dependent: :destroy

  scope :preload_associations, -> {
    preload(:user, :work_experiences, :education_histories, :industries, :jurisdictions, :skills)
  }

  scope :join_experience, -> {
    # TODO: Adjust when implementing rounding
    joins(:work_experiences)
      .select('specialists.*, SUM((COALESCE("to", NOW())::date - "from"::date) / 365) AS years_of_experience')
      .group(:id)
  }

  scope :experience_between, -> (min, max) {
    # TODO: Adjust when implementing rounding
    base_scope = join_experience.where(work_experiences: { compliance: true })
    if max
      base_scope
        .having('SUM((COALESCE("to", NOW())::date - "from"::date) / 365) BETWEEN ? AND ?', min, max)
    else
      base_scope
        .having('SUM((COALESCE("to", NOW())::date - "from"::date) / 365) > ?', min)
    end
  }

  scope :by_experience, -> (dir = :desc) {
    join_experience.order("years_of_experience #{dir}")
  }

  scope :by_distance, -> (lat, lng) do
    order("ST_Distance(point, ST_GeogFromText('SRID=4326;POINT(#{lng.to_f} #{lat.to_f})'))")
  end

  scope :close_to, -> (lat, lng, miles) do
    meters = miles.to_i * 1600
    where("ST_DWithin(point, ST_GeogFromText('SRID=4326;POINT(#{lng.to_f} #{lat.to_f})'), #{meters})")
  end

  scope :distance_between, -> (lat, lng, min, max) do
    min_m = min.to_i * 1600
    max_m = max.to_i * 1600
    distance = "ST_Distance(point, ST_GeogFromText('SRID=4326;POINT(#{lng.to_f} #{lat.to_f})'))"
    where("#{distance} >= ? AND #{distance} <= ?", min_m, max_m)
  end

  scope :public_profiles, -> { where(visibility: 'public') }

  include ImageUploader[:photo]
  include FileUploader[:resume]

  enum visibility:  { is_public: 'public', is_private: 'private' }

  def to_s
    full_name
  end

  def full_name
    [first_name, last_name].map(&:presence).compact.join(' ')
  end

  def public?
    is_public?
  end

  def private?
    is_private?
  end
end
