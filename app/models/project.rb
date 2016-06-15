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

  validates :title, :location, :jurisdictions, :industries, :description, :key_deliverables, presence: true
  validates :starts_on, :ends_on, :payment_schedule, :estimated_hours, presence: true
  validates :type, inclusion: { in: %w(one-off full-time) }
  validates :location, inclusion: { in: LOCATIONS.map(&:second) }

  before_validation :assign_pricing_type_fields

  attr_accessor :hourly_payment_schedule, :fixed_payment_schedule

  def hourly_pricing?
    pricing_type == 'hourly'
  end

  def fixed_pricing?
    pricing_type == 'fixed'
  end

  private

  def assign_pricing_type_fields
    if hourly_pricing?
      self.fixed_budget = nil
      self.payment_schedule = hourly_payment_schedule
    else
      self.hourly_rate = nil
      self.payment_schedule = fixed_payment_schedule
    end
  end
end
