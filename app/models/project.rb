# frozen_string_literal: true
class Project < ActiveRecord::Base
  self.inheritance_column = '_none'

  belongs_to :business
  has_and_belongs_to_many :industries
  has_and_belongs_to_many :jurisdictions

  LOCATIONS = [%w(Remote remote), %w(Remote\ +\ Travel remote-travel), %w(Onsite onsite)].freeze
  HOURLY_PAYMENT_SCHEDULES = [%w(Upon\ Completion upon-completion), %w(Bi-Weekly bi-weekly), %w(Monthly monthly)].freeze
  FIXED_PAYMENT_SCHEDULES = [%w(50/50 fifty-fifty), %w(Bi-Weekly bi-weekly), %w(Monthly monthly)].freeze
  MINIMUM_EXPERIENCE = [%w(3-7\ yrs 3-7), %w(7-10\ yrs 7-10), %w(11-15\ yrs 11-15), %w(15+\ yrs 15+)].freeze

  validates :type, inclusion: { in: %w(one-off full-time) }
  validates :title, :description, presence: true
  validates :location_type, inclusion: { in: LOCATIONS.map(&:second) }, allow_blank: true
  validates :location, presence: true, if: :location_required?
  validates :jurisdiction_ids, :industry_ids, presence: true

  ONE_OFF_FIELDS = %i(key_deliverables starts_on ends_on location_type payment_schedule estimated_hours).freeze
  FULL_TIME_FIELDS = %i(full_time_starts_on annual_salary).freeze

  validates(*ONE_OFF_FIELDS, presence: true, if: :one_off?)
  validates(*FULL_TIME_FIELDS, presence: true, if: :full_time?)

  validates :hourly_payment_schedule, :hourly_rate, presence: true, if: :hourly_pricing?
  validates :fixed_payment_schedule, :fixed_budget, presence: true, if: :fixed_pricing?
  validate if: -> { starts_on.present? && ends_on.present? } do
    errors.add :starts_on, :invalid if starts_on > ends_on
  end
  validate if: -> { starts_on.present? && ends_on.present? } do
    errors.add :ends_on, :invalid if ends_on < starts_on
  end
  validate if: -> { starts_on.present? && ends_on.present? && ends_on - starts_on < 14 } do
    attribute = hourly_pricing? ? :hourly_payment_schedule : :fixed_payment_schedule
    errors.add attribute, :too_little_duration if public_send(attribute) == 'monthly'
  end
  validate if: -> { starts_on.present? && ends_on.present? && ends_on - starts_on > 30 } do
    attribute = hourly_pricing? ? :hourly_payment_schedule : :fixed_payment_schedule
    errors.add attribute, :too_much_duration if public_send(attribute) == 'upon-completion'
  end

  before_validation :assign_type_fields
  before_validation :assign_pricing_type_fields

  attr_accessor :full_time_starts_on
  attr_accessor :hourly_payment_schedule, :fixed_payment_schedule

  def one_off?
    type == 'one-off'
  end

  def full_time?
    type == 'full-time'
  end

  def location_required?
    remote? || remote_and_travel? || full_time?
  end

  def remote?
    location_type == 'remote'
  end

  def remote_and_travel?
    location_type == 'remote-travel'
  end

  def hourly_pricing?
    one_off? && pricing_type == 'hourly'
  end

  def fixed_pricing?
    one_off? && pricing_type == 'fixed'
  end

  private

  def assign_type_fields
    clear_fields = one_off? ? FULL_TIME_FIELDS : ONE_OFF_FIELDS
    clear_fields.each do |field|
      next unless self.class.column_names.include?(field.to_s)
      self[field] = nil
    end
    true
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
