# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Project < ApplicationRecord
  self.inheritance_column = '_none'

  belongs_to :business
  belongs_to :specialist
  has_one :user, through: :business
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions
  has_and_belongs_to_many :skills
  has_many :issues, dependent: :delete_all, class_name: 'ProjectIssue'
  has_many :messages, as: :thread
  has_many :job_applications, dependent: :destroy
  has_many :timesheets, dependent: :destroy
  has_many :time_logs, through: :timesheets
  has_one :invite, class_name: 'ProjectInvite', dependent: :destroy
  has_many :end_requests, class_name: 'ProjectEnd', dependent: :destroy
  has_one :end_request, -> { pending }, class_name: 'ProjectEnd'
  has_many :ratings, dependent: :destroy
  has_many :charges, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :extensions, dependent: :destroy, class_name: 'ProjectExtension'
  has_one :extension, -> { pending }, class_name: 'ProjectExtension'
  has_many :documents, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, through: :questions, dependent: :destroy
  has_many :favorites, as: :favorited, dependent: :destroy, class_name: 'Favorite'
  has_many :favorited_by, through: :favorites, source_type: 'Specialist', source: :owner

  # add favorites or specialists who favorited this project

  accepts_nested_attributes_for :extensions
  accepts_nested_attributes_for :timesheets, allow_destroy: true

  scope :business_timezones, -> { joins(business: :user).select('projects.*, businesses.time_zone') }
  scope :escalated, -> { joins(:issues).where(project_issues: { status: :open }) }
  scope :not_escalated, -> { where.not(id: escalated) }
  scope :visible, -> { joins(business: :user).where(users: { suspended: false }) }
  scope :recent, -> { order(published_at: :desc) }
  scope :draft_and_in_review, -> { where(status: [statuses[:draft], statuses[:review]]) }
  scope :published, -> { where(status: statuses[:published]) }
  scope :pending, -> { published.where(specialist_id: nil) }
  scope :expired, -> { pending.where('expires_at < ?', Time.zone.now) }
  scope :active, -> { published.where.not(specialist_id: nil) }
  # TODO: Maybe add an "archived" flag so we can filter these projects more easily
  # Then in the PaymentCycle class, set archived = true when a project is complete and
  # has got all charges created.
  scope :active_for_charges, -> {
    not_escalated
      .where(
        'status = :published AND specialist_id IS NOT NULL',
        published: statuses[:published]
      )
  }
  scope :complete, -> { where(status: statuses[:complete]).not_escalated }
  scope :accessible_by, ->(user) {
    # Accessible by project owner, hired specialist, or everyone if it's published
    joins(:business).joins('LEFT OUTER JOIN specialists ON specialists.id = projects.specialist_id')
                    .where('businesses.user_id = :user_id
                      OR specialists.user_id = :user_id
                      OR projects.status = :status', status: 'published', user_id: user.id)
  }

  scope :onsite, -> { where(location_type: location_types[:onsite]) }
  scope :remote, -> { where(location_type: location_types[:remote]) }
  scope :remote_and_travel, -> { where(location_type: location_types[:remote_and_travel]) }

  scope :with_skills, ->(names) { joins(:skills).where(skills: { name: Array(names) }) }

  scope :preload_associations, -> {
    preload(:business, :jurisdictions, :industries, :end_request)
  }

  scope :distance_between, ->(lat, lng, min, max) do
    min_m = min.to_i * 1600
    max_m = max.to_i * 1600
    distance = "ST_Distance(point, ST_GeogFromText('SRID=4326;POINT(#{lng.to_f} #{lat.to_f})'))"
    where("#{distance} >= ? AND #{distance} <= ?", min_m, max_m)
  end

  scope :pending_business_rating, -> {
    complete
      .one_off
      .joins("LEFT JOIN ratings ON ratings.project_id = projects.id AND ratings.rater_type = '#{Business.name}'")
      .where(ratings: { id: nil })
  }

  scope :pending_specialist_rating, -> {
    complete
      .one_off
      .joins("LEFT JOIN ratings ON ratings.project_id = projects.id AND ratings.rater_type = '#{Specialist.name}'")
      .where(ratings: { id: nil })
  }

  scope :unsolicited_business_rating, -> {
    where(solicited_business_rating: false)
  }

  scope :unsolicited_specialist_rating, -> {
    where(solicited_specialist_rating: false)
  }

  include Project::PgSearchConfig

  enum status: {
    draft: 'draft',
    review: 'review',
    published: 'published',
    complete: 'complete'
  }

  enum type: {
    one_off: 'one_off',
    full_time: 'full_time'
  }

  enum location_type: {
    remote: 'remote',
    remote_and_travel: 'remote_and_travel',
    onsite: 'onsite'
  }

  enum fee_type: {
    upfront_fee: 'upfront_fee',
    monthly_fee: 'monthly_fee'
  }

  LOCATIONS = [%w[Remote remote], %w[Remote\ +\ Travel remote_and_travel], %w[Onsite onsite]].freeze
  # DB Views depend on these so don't modify:
  HOURLY_PAYMENT_SCHEDULES = [%w[Upon\ Completion upon_completion], %w[Bi-Weekly bi_weekly], %w[Monthly monthly]].freeze
  FIXED_PAYMENT_SCHEDULES = [
    %w[50/50 fifty_fifty],
    %w[Upon\ Completion upon_completion],
    %w[Bi-Weekly bi_weekly],
    %w[Monthly monthly]
  ].freeze
  PAYMENT_SCHEDULES = (HOURLY_PAYMENT_SCHEDULES + FIXED_PAYMENT_SCHEDULES).uniq.freeze
  enum payment_schedule: Hash[PAYMENT_SCHEDULES].invert

  MINIMUM_EXPERIENCE = ((3..14).map { |n| ["#{n} yrs", n] } + [['15+ yrs', 15]]).freeze
  EXPERIENCE_RANGES = (1..15).each_with_object({}) do |n, years|
    years[n] = (n..Float::INFINITY)
  end.freeze

  before_save :save_expires_at, if: -> { starts_on_changed? }

  def self.ending
    one_off.active.joins(business: :user).select('projects.*, businesses.time_zone').find_each.find_all(&:ending?)
  end

  def self.ends_in_24
    one_off.active.where(ends_in_24: false).business_timezones.find_each.find_all do |p|
      # Set to midnight
      tz = ActiveSupport::TimeZone[p[:time_zone]]
      p.ends_on.in_time_zone(tz) - 1.day <= 5.minutes.from_now
    end
  end

  def self.starts_in_48
    one_off.where(starts_in_48: false).business_timezones.find_each.find_all do |project|
      next if project.asap_duration?

      # Set to midnight
      tz = ActiveSupport::TimeZone[project[:time_zone]]
      start_time = project.starts_on.in_time_zone(tz) - 2.days
      (start_time <= 10.minutes.from_now) && (start_time >= Time.zone.now)
    end
  end

  def self.cards_for_user(user, filter:)
    user.business.projects.recent
        .includes(:industries, :jurisdictions, :skills)
        .public_send(filter)
  end

  def complete!
    super
    touch :completed_at
  end

  def requires_business_rating?
    one_off? && complete? && !solicited_business_rating
  end

  def requires_specialist_rating?
    one_off? && complete? && !solicited_specialist_rating
  end

  def ending?
    hard_ends_on <= 5.minutes.from_now
  end

  def past_ends_on?
    return false if pending? && asap_duration?
    ends_on.in_time_zone(time_zone).past?
  end

  def hard_ends_on
    if fixed_pricing?
      ends_on.in_time_zone(time_zone).end_of_day
    else
      BufferDate.for(ends_on, time_zone: time_zone)
    end
  end

  def time_zone
    @time_zone ||= ActiveSupport::TimeZone[attributes[:time_zone].presence || business.time_zone]
  end

  def end_requested?
    end_request.present?
  end

  def extension_requested?
    extension.present?
  end

  def parties
    [business, specialist]
  end

  def to_s
    title
  end

  def application(specialist)
    job_applications.where(specialist_id: specialist.id)
  end

  def escalated?
    issues.open.any?
  end

  def disputed_timesheets?
    timesheets.disputed.exists?
  end

  def submitted_timesheets?
    timesheets.submitted.exists?
  end

  def applied?(specialist)
    application(specialist).exists?
  end

  def skill_names
    @skill_names.nil? ? skills.map(&:name) : @skill_names
  end

  def skill_names=(names)
    self.skills = names.map do |name|
      Skill.find_or_initialize_by(name: name)
    end
  end

  def pending?
    specialist_id.nil?
  end

  def active?
    published? && specialist_id.present? && (hard_ends_on.future? || escalated?)
  end

  def finishing?
    published? && past_ends_on?
  end

  def draft_or_review?
    status == self.class.statuses[:draft] || status == self.class.statuses[:review]
  end

  def location_required?
    onsite? || remote_and_travel? || full_time?
  end

  def asap_duration?
    duration_type == 'asap'
  end

  def custom_duration?
    duration_type == 'custom'
  end

  def hourly_pricing?
    one_off? && pricing_type == 'hourly'
  end

  def fixed_pricing?
    one_off? && pricing_type == 'fixed'
  end

  private

  def save_expires_at
    return if starts_on.blank?
    self.expires_at = starts_on.in_time_zone(time_zone).end_of_day
  end
end
# rubocop:enable Metrics/ClassLength
