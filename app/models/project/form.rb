# frozen_string_literal: true

class Project::Form < Project
  include ApplicationForm

  validates :title, :description, presence: true
  validates :location_type, inclusion: { in: Project::LOCATIONS.map(&:second) }, allow_blank: true
  validates :location, presence: true, if: :location_required?
  validates :jurisdiction_ids, :industry_ids, presence: true

  ONE_OFF_FIELDS = %i[key_deliverables location_type payment_schedule estimated_hours].freeze
  FULL_TIME_FIELDS = %i[full_time_starts_on annual_salary].freeze
  SHARED_FIELDS = %i[starts_on].freeze
  RFP_FIELDS = %i[location_type est_budget rfp_timing].freeze

  ASAP_DURATION_FIELDS = %i[estimated_days].freeze
  CUSTOM_DURATION_FIELDS = %i[starts_on ends_on].freeze

  validates(*RFP_FIELDS, presence: true, if: :rfp?)
  validates(*ONE_OFF_FIELDS, presence: true, if: :one_off?)
  validates(*FULL_TIME_FIELDS, presence: true, if: :full_time?)
  validates(*ASAP_DURATION_FIELDS, presence: true, if: :asap_duration?)
  validates(*CUSTOM_DURATION_FIELDS, presence: true, if: :custom_duration?)

  validates :hourly_rate, presence: true, if: :hourly_pricing?
  validates :fixed_budget, presence: true, if: :fixed_pricing?
  validates :hourly_payment_schedule, :hourly_rate,
            presence: true, if: -> { hourly_pricing? && payment_schedule.blank? }
  validates :fixed_payment_schedule, :fixed_budget,
            presence: true, if: -> { fixed_pricing? && payment_schedule.blank? }
  validate if: -> { asap_duration? } do
    errors.add :starts_on, :duration if starts_on.present?
    errors.add :ends_on, :duration if ends_on.present?
  end
  validate if: -> { custom_duration? } do
    errors.add :estimated_days, :duration if estimated_days.present?
  end
  validate if: -> { starts_on.present? } do
    errors.add :starts_on, :past if starts_on.in_time_zone(business.tz).to_date < business.tz.today
  end
  validate if: -> { starts_on.present? && ends_on.present? } do
    errors.add :starts_on, :invalid if starts_on > ends_on
  end
  validate if: -> { starts_on.present? && ends_on.present? } do
    errors.add :ends_on, :invalid if ends_on < starts_on
  end
  validate if: -> { starts_on.present? && ends_on.present? && ends_on - starts_on < 14 } do
    attribute = hourly_pricing? ? :hourly_payment_schedule : :fixed_payment_schedule
    period = public_send(attribute)
    errors.add attribute, :too_little_duration if %w[monthly bi_weekly].include?(period)
  end
  validate if: -> { published? && !user&.payment_info? } do
    errors.add :base, :no_payment
  end
  validates :skill_ids, length: { maximum: 10 }
  validates :minimum_experience, presence: true, inclusion: { in: EXPERIENCE_RANGES.keys }

  before_validation :assign_type_fields
  before_validation :assign_duration_type_fields
  before_validation :assign_pricing_type_fields

  attr_accessor :full_time_starts_on
  attr_accessor :hourly_payment_schedule, :fixed_payment_schedule
  attr_accessor :invite_id

  ATTRIBUTES_FOR_COPY = %w[
    annual_salary business_id description estimated_hours fee_type fixed_budget hourly_rate key_deliverables
    location_type location minimum_experience only_regulators payment_schedule pricing_type status title type
  ].freeze

  def self.copy(original, attributes = {})
    new(original.attributes.slice(*ATTRIBUTES_FOR_COPY)).tap do |copy|
      copy.attributes = attributes
      copy.industries = original.industries
      copy.jurisdictions = original.jurisdictions
      copy.skills = original.skills
    end
  end

  def save(_options = {})
    published_now = published? && status_changed?
    self.published_at = Time.current if published_now
    result = super
    process_invite(published_now) if result && (invite || invite_id.present?)
    result
  end

  def post!
    published!
    touch :published_at
    process_invite true if invite&.not_sent?
  end

  def full_time_starts_on
    @full_time_starts_on.present? ? Date.parse(@full_time_starts_on) : starts_on
  end

  def hourly_payment_schedule
    @hourly_payment_schedule || payment_schedule
  end

  def fixed_payment_schedule
    @fixed_payment_schedule || payment_schedule
  end

  private

  def process_invite(published_now)
    invite = self.invite || business.project_invites.find(invite_id)
    invite.update_attribute :project_id, id if invite.project_id.blank?
    invite.send_message! if published_now
  end

  # Clear unnecessary fields
  def assign_type_fields
    fields = if one_off?
               FULL_TIME_FIELDS - SHARED_FIELDS
             elsif rfp?
               FULL_TIME_FIELDS - ONE_OFF_FIELDS - RFP_FIELDS
             else
               ONE_OFF_FIELDS - SHARED_FIELDS
             end

    clear_fields(fields)
    true
  end

  def clear_fields(fields)
    fields.each do |field|
      next unless self.class.column_names.include?(field.to_s)
      self[field] = nil
    end
  end

  def assign_duration_type_fields
    return unless full_time?
    self.duration_type = nil
    self.estimated_days = nil
  end

  def assign_pricing_type_fields
    if full_time?
      self.fixed_budget = nil
      self.hourly_rate = nil
      self.starts_on = full_time_starts_on
    elsif hourly_pricing?
      self.fixed_budget = nil
      self.payment_schedule = hourly_payment_schedule
    else
      self.hourly_rate = nil
      self.payment_schedule = fixed_payment_schedule
    end
    true
  end
end
