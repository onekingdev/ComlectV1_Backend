# frozen_string_literal: true
class PaymentCycle
  attr_reader :project

  SCHEDULE_CLASSES = {
    "hourly/upon_completion" => PaymentCycle::Hourly::UponCompletion,
    "hourly/bi_weekly" => PaymentCycle::Hourly::BiWeekly,
    "hourly/monthly" => PaymentCycle::Hourly::Monthly,
    "fixed/fifty_fifty" => PaymentCycle::Fixed::FiftyFifty,
    "fixed/upon_completion" => PaymentCycle::Fixed::UponCompletion,
    # "fixed/bi_weekly" => PaymentCycle::Fixed::BiWeekly,
    # "fixed/monthly" => PaymentCycle::Fixed::Monthly
  }.freeze

  def self.for(project)
    hourly_or_fixed = project.hourly_pricing? ? 'hourly' : 'fixed'
    klass = SCHEDULE_CLASSES.fetch("#{hourly_or_fixed}/#{project.payment_schedule.parameterize.underscore}")
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

  def reschedule!
    project.charges.estimated.delete_all
    remaining_dates = occurrences.reject { |date| charge_exists?(date) }
    amounts = outstanding_amount / remaining_dates.size
    remaining_dates.each do |date|
      create_estimated_charge! amount: amounts, date: date
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

  def create_charges!
    date = current_cycle_date
    ActiveRecord::Base.transaction do
      project.timesheets.approved.each do |timesheet|
        schedule_charge! amount: timesheet.total_due,
                         date: date,
                         description: "Timesheet #{timesheet.id}"
        timesheet.charged!
      end
    end
  end

  def charge_current!(amount:, description:)
    date = current_cycle_date
    project.charges.create! amount_in_cents: amount * 100,
                            status: Project.statuses[:scheduled],
                            date: date,
                            process_after: calculate_process_at_date(date),
                            description: description
  end

  private

  def current_cycle_date
    all_occurrences = occurrences
    all_occurrences.detect(&:future?) || all_occurrences.last
  end

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
