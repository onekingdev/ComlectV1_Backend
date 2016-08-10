# frozen_string_literal: true
class Project < ActiveRecord::Base
  self.inheritance_column = '_none'

  belongs_to :business
  has_one :user, through: :business
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :skills
  has_many :issues, dependent: :delete_all, class_name: 'ProjectIssue'

  scope :recent, -> { order(created_at: :desc) }
  scope :published, -> { where(status: 'published') }
  scope :active, -> { none } # TODO: Applicant selected
  scope :pending, -> { published } # TODO: Applicant not yet selected
  scope :complete, -> { none } # TODO: User marked as complete
  scope :draft_and_in_review, -> { where(status: %w(draft review)) }
  scope :accessible_by, -> (user) { joins(:business).where('user_id = ? OR status = ?', user.id, 'published') }

  scope :one_off, -> { where(type: 'one_off') }
  scope :full_time, -> { where(type: 'full_time') }

  scope :onsite, -> { where(location_type: 'onsite') }
  scope :remote, -> { where(location_type: 'remote') }
  scope :remote_and_travel, -> { where(location_type: 'remote_and_travel') }

  scope :with_skills, -> (names) { joins(:skills).where(skills: { name: Array(names) }) }

  scope :preload_associations, -> {
    preload(:business, :jurisdictions, :industries)
  }

  scope :distance_between, -> (lat, lng, min, max) do
    min_m = min.to_i * 1600
    max_m = max.to_i * 1600
    distance = "ST_Distance(point, ST_GeogFromText('SRID=4326;POINT(#{lng.to_f} #{lat.to_f})'))"
    where("#{distance} >= ? AND #{distance} <= ?", min_m, max_m)
  end

  include PgSearch
  pg_search_scope :search,
                  against: %i(title description),
                  using: {
                    tsearch: {
                      dictionary: 'english',
                      tsvector_column: 'tsv'
                    }
                  }

  enum status: { draft: 'draft', review: 'review', published: 'published' }
  enum type: { one_off: 'one_off', full_time: 'full_time' }
  enum location_type: { remote: 'remote', remote_and_travel: 'remote_and_travel', onsite: 'onsite' }

  LOCATIONS = [%w(Remote remote), %w(Remote\ +\ Travel remote_and_travel), %w(Onsite onsite)].freeze
  HOURLY_PAYMENT_SCHEDULES = [%w(Upon\ Completion upon_completion), %w(Bi-Weekly bi_weekly), %w(Monthly monthly)].freeze
  FIXED_PAYMENT_SCHEDULES = [
    %w(50/50 fifty_fifty),
    %w(Upon\ Completion upon_completion),
    %w(Bi-Weekly bi_weekly),
    %w(Monthly monthly)
  ].freeze
  PAYMENT_SCHEDULES = (HOURLY_PAYMENT_SCHEDULES + FIXED_PAYMENT_SCHEDULES).uniq.freeze
  MINIMUM_EXPERIENCE = [%w(3-7\ yrs 3-7), %w(7-10\ yrs 7-10), %w(11-15\ yrs 11-15), %w(15+\ yrs 15+)].freeze

  def self.cards_for_user(user, filter:, page:, per:)
    user.business.projects.recent
        .includes(:industries, :jurisdictions, :skills)
        .public_send(filter)
        .page(page).per(per || 6)
  end

  def to_s
    title
  end

  def skill_names
    @skill_names.nil? ? skills.map(&:name) : @skill_names
  end

  def skill_names=(names)
    self.skills = names.map do |name|
      Skill.find_or_initialize_by(name: name)
    end
  end

  def post!
    update_attribute :status, Project.statuses[:published]
  end

  def pending?
    rand(2) == 1 # TODO
  end

  def active?
    rand(2) == 1 # TODO
  end

  def complete?
    rand(2) == 1 # TODO
  end

  def applications_counts
    0 # TODO
  end

  def draft_or_review?
    status == self.class.statuses[:draft] || status == self.class.statuses[:review]
  end

  def location_required?
    onsite? || remote_and_travel? || full_time?
  end

  def hourly_pricing?
    one_off? && pricing_type == 'hourly'
  end

  def fixed_pricing?
    one_off? && pricing_type == 'fixed'
  end
end
