# frozen_string_literal: true
class Specialist < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :skills
  has_many :work_experiences, dependent: :destroy
  has_many :education_histories, dependent: :delete_all

  scope :preload_associations, -> {
    includes(:user, :work_experiences, :education_histories, :industries, :jurisdictions, :skills)
  }

  scope :join_experience, -> {
    joins(:work_experiences)
      .select('specialists.*, SUM((COALESCE("to", NOW())::date - "from"::date) / 365) AS years_of_experience')
      .group(:id)
  }

  scope :experience_between, -> (min, max) {
    join_experience
      .having('SUM((COALESCE("to", NOW())::date - "from"::date) / 365) BETWEEN ? AND ?', min, max)
  }

  scope :by_experience, -> (dir = :desc) {
    join_experience.order("years_of_experience #{dir}")
  }

  include ImageUploader[:photo]
  include FileUploader[:resume]

  enum visibility:  { is_public: 'public', is_private: 'private' }

  def to_s
    [first_name, last_name].map(&:presence).compact.join(' ')
  end

  def public?
    is_public?
  end

  def private?
    is_private?
  end
end
