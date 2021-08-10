# frozen_string_literal: true

class Project < ApplicationRecord
  self.inheritance_column = '_none'

  alias_attribute :remind_at, :starts_on
  alias_attribute :end_date, :ends_on
  alias_attribute :done_at, :completed_at
  alias_attribute :body, :title

  belongs_to :business
  belongs_to :specialist, optional: true
  belongs_to :local_project, optional: true
  has_one :user, through: :business
  has_and_belongs_to_many :industries, optional: true
  has_and_belongs_to_many :jurisdictions, optional: true
  has_and_belongs_to_many :skills, optional: true
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
  has_many :questions, dependent: :destroy
  has_many :answers, through: :questions, dependent: :destroy
  has_many :favorites, as: :favorited, dependent: :destroy, class_name: 'Favorite'
  has_many :favorited_by, through: :favorites, source_type: 'Specialist', source: :owner
  has_many :applicants, class_name: 'Specialist', through: :job_applications, source: :specialist

  accepts_nested_attributes_for :extensions
  accepts_nested_attributes_for :timesheets, allow_destroy: true

  scope :time_assigned, -> { where.not(starts_on: nil).where.not(ends_on: nil) }
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

  scope :preload_association, -> {
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
      .one_off.or(rfp)
      .joins("LEFT JOIN ratings ON ratings.project_id = projects.id AND ratings.rater_type = '#{Business.name}'")
      .where(ratings: { id: nil })
  }

  scope :pending_specialist_rating, -> {
    complete
      .one_off.or(rfp)
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
    full_time: 'full_time',
    rfp: 'rfp',
    internal: 'internal'
  }

  enum applicant_selection: {
    auto_match: 'auto_match',
    interview: 'interview'
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

  after_create :new_project_notification
  after_update :new_project_notification
  after_create :send_email, if: :internal?
  before_create :check_specialist, if: :internal?
  before_create :fix_internal_asap, if: :internal?
  before_create :remove_specialist, unless: :internal? if Rails.env != 'test'
  # before_create :calculate_budget

  LOCATIONS = [%w[Remote remote], %w[Remote\ +\ Travel remote_and_travel], %w[Onsite onsite]].freeze
  # DB Views depend on these so don't modify:
  HOURLY_PAYMENT_SCHEDULES = [
    %w[Upon\ Completion upon_completion],
    %w[Bi-Weekly bi_weekly],
    %w[Monthly monthly]
  ].freeze
  FIXED_PAYMENT_SCHEDULES = [
    %w[Upfront upfront],
    %w[50/50 fifty_fifty],
    %w[Upon\ Completion upon_completion],
    %w[Bi-Weekly bi_weekly],
    %w[Monthly monthly]
  ].freeze
  PAYMENT_SCHEDULES = (HOURLY_PAYMENT_SCHEDULES + FIXED_PAYMENT_SCHEDULES).uniq.freeze
  enum payment_schedule: Hash[PAYMENT_SCHEDULES].invert
  MINIMUM_EXPERIENCE = [['Junior', 0], ['Intermediate', 1], ['Expert', 2]].freeze
  EXPERIENCE_RANGES = (0..2).each_with_object({}) do |n, years|
    years[n] = (n..Float::INFINITY)
  end.freeze

  before_save :save_expires_at, if: -> { starts_on_changed? }

  def start_time
    starts_on
  end

  def body
    title
  end

  def end_time
    ends_on
  end

  def populate_rfp(job_application)
    if rfp?
      %w[starts_on ends_on key_deliverables payment_schedule pricing_type fixed_budget hourly_rate estimated_hours].each do |m|
        public_send("#{m}=", job_application.public_send(m))
      end
      self.description = job_application.message
      self.type = 'one_off'
    end
    self
  end

  def populate_rfp_specialist(rfp_specialist)
    ja = job_applications.where(specialist_id: rfp_specialist.id)
    if ja.present?
      populate_rfp(ja.first)
    else
      self
    end
  end

  def job_application
    if active? && rfp?
      ja = job_applications.where(specialist_id: specialist_id)
      ja.present? ? ja.first : nil
    end
  end

  def self.ending
    one_off.or(rfp).or(internal).active.joins(business: :user).select('projects.*, businesses.time_zone').find_each.find_all(&:ending?)
  end

  def self.ends_in_24
    one_off.or(rfp).active.where(ends_in_24: false).business_timezones.find_each.find_all do |p|
      # Set to midnight
      tz = ActiveSupport::TimeZone[p[:time_zone]]
      p.ends_on.in_time_zone(tz) - 1.day <= 5.minutes.from_now
    end
  end

  def self.starts_in_48
    one_off.or(rfp).where(starts_in_48: false).where.not(starts_on: nil).business_timezones.find_each.find_all do |project|
      next if project.asap_duration?

      # Set to midnight
      tz = ActiveSupport::TimeZone[project[:time_zone]]
      start_time = project.starts_on.in_time_zone(tz) - 2.days
      (start_time <= 10.minutes.from_now) && (start_time >= Time.zone.now)
    end
  end

  def self.cards_for_user(user, filter:)
    (user.specialist || user.business).projects.recent
                                      .includes(:industries, :jurisdictions, :skills)
                                      .public_send(filter)
  end

  def complete!
    super
    touch :completed_at
  end

  def requires_business_rating?
    !full_time? && complete? && !solicited_business_rating
  end

  def requires_specialist_rating?
    !full_time? && complete? && !solicited_specialist_rating
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

  # something strange here
  # we have this method as `alias_attribute`
  # rubocop:disable Lint/DuplicateMethods
  def body
    title
  end
  # rubocop:enable Lint/DuplicateMethods

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
    if ends_on.present?
      published? && specialist_id.present? && (hard_ends_on.future? || escalated?)
    else
      published? && specialist_id.present?
    end
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
    !full_time? && pricing_type == 'hourly'
  end

  def fixed_pricing?
    !full_time? && pricing_type == 'fixed'
  end

  def build_from_template(businessid, template, params)
    %i[location_type key_deliverables pricing_type hourly_rate only_regulators annual_salary
       fee_type minimum_experience duration_type estimated_days business_fee_free applicant_selection].each do |attr|
      public_send("#{attr}=", template.public_send(attr.to_s))
    end

    solution = template.turnkey_solution
    params_bd = params[:bd].reject(&:empty?) if params.include?(:bd)

    self.fixed_budget = template.flavor == 'bd' ? calculate_bd(params_bd)[0] : template.fixed_budget
    self.business_id = businessid
    self.type = template.project_type
    self.status = 'published'

    self.title = if solution.aum_enabled && check_aum(params[:aum]) && !template.title_aum.empty?
      template.title_aum
    else
      template.title
    end

    title.gsub!('{state}', params[:state]) if solution.principal_office
    self.location = params[:state] if solution.principal_office

    self.description = if solution.aum_enabled && check_aum(params[:aum]) && !template.description_aum.empty?
      template.description_aum
    else
      template.description
    end

    self.description = format_description(description, params)
    self.payment_schedule = payment_schedule_to_name(template.payment_schedule)

    self.estimated_hours = if solution.hours_enabled
      params[:estimated_hours].to_i
    else
      template.flavor == 'bd' ? calculate_bd(params_bd)[1] : template.estimated_hours
    end

    self.industries = if solution.industries_enabled
      Industry.where(id: params[:industries].reject(&:empty?).map(&:to_i))
    else
      template.industries
    end

    self.jurisdictions = if solution.jurisdictions_enabled
      Jurisdiction.where(id: params[:jurisdictions].reject(&:empty?).map(&:to_i))
    else
      template.jurisdictions
    end

    self
  end

  def self.all_bds
    [['EMC', 3], ['BIA', 1], ['MFU', 2], ['MSD', 1], ['TAS', 1], ['SSL', 1],\
     ['EMF', 3], ['NEX', 1], ['MFR', 2], ['MSB', 1], ['PLA', 1], ['IAD', 1],\
     ['IDM', 3], ['BDD', 1], ['VLA', 1], ['OGI', 1], ['PCB', 2], ['MRI', 1],\
     ['TRA', 3], ['USG', 2], ['GSD', 1], ['NPB', 2], ['BNA', 2], ['OTH', 2],\
     ['BDR', 2], ['RES', 1], ['GSB', 1], ['TAP', 1], ['INA', 2], ['LP', 0]]
  end

  def self.bd_prices_and_hours
    # price, base hours, additional hours for 3 selected, additional USD
    [[1200, 70, 0, 0], [20_000, 115, 30, 5000], [65_000, 370, 30, 5000], [135_000, 775, 0, 0]]
  end

  def check_aum(str)
    vocab = [%w[BN bn Billion billion Bill bill], '000000000'], \
            [%w[Million million MM mm Mill mill], '000000']
    result = str.to_i.to_s
    occured = false
    vocab.each do |v|
      v[0].each do |word|
        if str.include?(word) && !occured
          result += v[1]
          occured = true
        end
      end
    end
    result.to_i > 100_000_000
  end

  def calculate_bd(bds)
    # 0 = 12000 yellow
    # 1 = 20000 gray
    # 2 = 65000 blue
    # 3 = 135000 orange
    filtered = Project.all_bds.select { |f| bds.uniq.include?(f[0]) }
    base = filtered.max_by { |a| a[1] }
    base_price = Project.bd_prices_and_hours[base[1]][0]
    base_hours = Project.bd_prices_and_hours[base[1]][1]
    g = {}
    filtered.each { |s| g.key?(s[1]) ? g[s[1]] += 1 : g[s[1]] = 1 }
    add_price = 0
    add_hours = 0
    g.each do |k, v|
      cnt = v / 3
      if cnt.positive?
        add_price += Project.bd_prices_and_hours[k][3] * cnt
        add_hours += Project.bd_prices_and_hours[k][2] * cnt
      end
    end
    [base_price + add_price, base_hours + add_hours]
  end

  def new_project_notification
    environment = ENV['STRIPE_PUBLISHABLE_KEY'].start_with?('pk_test') ? 'staging' : 'production'
    environment = 'staging' if Rails.env.development?
    if !admin_notified && !draft? && environment == 'production'
      ProjectMailer.notify_admin_on_creation(self).deliver_later
      update(admin_notified: true)
      save!
    end
  end

  def send_email
    Notification::Deliver.got_assigned! self
  end

  def check_specialist
    assigned_team_members_ids = business.seats.pluck(:team_member_id).compact
    assigned_team_members = TeamMember.where(id: assigned_team_members_ids).pluck(:email).compact
    if specialist
      email = specialist.user.present? ? specialist.user.email : ''
      if assigned_team_members.include? email
        true
      else
        errors.add :base, 'Invalid specialist'
        false
      end
    else
      errors.add :base, 'Invalid specialist'
      false
    end
  end

  def fix_internal_asap
    return if duration_type != 'asap'
    self.starts_on = Time.zone.now.in_time_zone(business.time_zone)
    self.ends_on = starts_on + estimated_days.days
  end

  def remove_specialist
    self.specialist_id = nil
  end

  private

  def calculate_budget
    self.calculated_budget = hourly_pricing? ? (hourly_rate + upper_hourly_rate / 2) * estimated_hours : fixed_budget
  end

  def format_description(description, params)
    description.gsub!('{state}', params[:state]) if params.include? :state
    description.gsub!('{aum}', params[:aum]) if params.include? :aum
    description.gsub!('{bd}', params[:bd].reject(&:empty?).join(', ')) if params.include? :bd
    description += ' We have {accounts} client accounts.'.gsub('{accounts}', params[:accounts]) if params.include? :accounts
    description
  end

  def payment_schedule_to_name(identifer)
    n = ''
    Project::PAYMENT_SCHEDULES.each do |s|
      n = s[0] if s.include?(identifer)
    end
    n
  end

  def save_expires_at
    return if starts_on.blank?
    self.expires_at = starts_on.in_time_zone(time_zone).end_of_day
  end
end
