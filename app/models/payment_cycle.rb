# frozen_string_literal: true
class PaymentCycle
  attr_reader :project

  SCHEDULE_CLASSES = {
    "hourly/upon_completion" => PaymentCycle::Hourly::UponCompletion,
    "hourly/bi_weekly" => PaymentCycle::Hourly::BiWeekly,
    "hourly/monthly" => PaymentCycle::Hourly::Monthly,
    # "fixed/50_50" => PaymentCycle::Fixed::FiftyFifty,
    # "fixed/upon_completion" => PaymentCycle::Fixed::UponCompletion,
    # "fixed/bi_weekly" => PaymentCycle::Fixed::BiWeekly,
    # "fixed/monthly" => PaymentCycle::Fixed::Monthly
  }.freeze

  def self.for(project)
    hourly_or_fixed = project.hourly_pricing? ? 'hourly' : 'fixed'
    klass = SCHEDULE_CLASSES["#{hourly_or_fixed}/#{project.payment_schedule.parameterize.underscore}"]
    klass.new(project)
  end

  def initialize(project)
    raise 'Payment cycles only available for one-off projects' unless project.one_off?
    @project = project
  end

  def create_charges_and_reschedule!
    ActiveRecord::Base.transaction do
      create_charges!
      reschedule!
    end
  end

  def schedule_charge!(amount:, date:, description:)
    project.charges.create! amount_in_cents: amount * 100,
                            date: date,
                            process_after: calculate_process_at_date(date),
                            status: Charge.statuses[:scheduled],
                            description: description
  end

  def create_estimated_charge!(amount:, date:)
    project.charges.create! status: Charge.statuses[:estimated],
                            amount_in_cents: amount * 100,
                            date: date,
                            process_after: calculate_process_at_date(date)
  end

  def outstanding_amount
    estimated_total - project.charges.real.sum(:amount_in_cents) / 100.0
  end

  def charge_exists?(datetime)
    project.charges.where(date: datetime).exists?
  end

  private

  WEEKDAY_BUFFERS = Hash.new(1.day).merge(
    5 => 3.days, # Friday? Push to monday
    6 => 3.days, # Saturday? Push to tuesday
    0 => 2.days  # Sunday? Push to tuesday
  ).freeze

  def calculate_process_at_date(date)
    process_at = date.to_date + WEEKDAY_BUFFERS[date.wday]
    process_at.in_time_zone(timezone) + 1.minute
  end

  def timezone
    @_timezone ||= project.business.tz
  end
end
