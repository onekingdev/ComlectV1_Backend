# frozen_string_literal: true

class PaymentCycle
  attr_reader :project

  SCHEDULE_CLASSES = {
    'hourly/upon_completion' => PaymentCycle::Hourly::UponCompletion,
    'hourly/bi_weekly' => PaymentCycle::Hourly::BiWeekly,
    'hourly/monthly' => PaymentCycle::Hourly::Monthly,
    'fixed/fifty_fifty' => PaymentCycle::Fixed::FiftyFifty,
    'fixed/upon_completion' => PaymentCycle::Fixed::UponCompletion,
    'fixed/bi_weekly' => PaymentCycle::Fixed::BiWeekly,
    'fixed/monthly' => PaymentCycle::Fixed::Monthly
  }.freeze

  def self.for(project)
    return PaymentCycle::FullTime.new(project) if project.full_time?
    hourly_or_fixed = project.hourly_pricing? ? 'hourly' : 'fixed'
    klass = SCHEDULE_CLASSES.fetch("#{hourly_or_fixed}/#{project.payment_schedule.parameterize.underscore}")
    klass.new(project)
  end

  def initialize(project)
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
    remaining_dates = outstanding_occurrences
    balance = outstanding_amount
    return unless balance.positive?

    remaining_dates.each do |date|
      amount = amount_for(date, remaining_dates: remaining_dates)
      balance -= amount

      create_estimated_charge!(
        amount: amount,
        balance: balance,
        date: date
      )
    end
  end

  def amount_for(date = nil, remaining_dates: [])
    return unless remaining_dates.any? || date
    outstanding_amount / (remaining_dates.presence || [date].compact.presence).size
  end

  def schedule_charge!(amount:, date:, description:, referenceable: nil)
    Rails.logger.info "Scheduling charge for project: #{project.id}. Ends on: #{project.ends_on}."
    Rails.logger.info "Date: #{date}."

    project.charges.create!(
      amount_in_cents: amount * 100,
      running_balance_in_cents: balance_after(amount, cut_off: date) * 100,
      date: date,
      process_after: calculate_process_at_date(date),
      status: Charge.statuses[:scheduled],
      description: description,
      referenceable: referenceable
    )
  end

  def create_estimated_charge!(amount:, date:, balance:)
    project.charges.create!(
      status: Charge.statuses[:estimated],
      amount_in_cents: amount * 100,
      running_balance_in_cents: balance * 100,
      date: date,
      process_after: calculate_process_at_date(date)
    )
  end

  def outstanding_amount
    # Note this cannot be cached otherwise running balances will be wrong after charges are created
    amount = (estimated_total - project.charges.real.sum(:amount_in_cents) / 100.0)
    amount.negative? ? 0 : amount
  end

  def outstanding_occurrences
    occurrences.reject { |date| charge_exists?(date) }
  end

  def charge_exists?(datetime)
    project.charges.real.where(date: datetime).exists?
  end

  private

  def balance_after(amount, cut_off:)
    return 0 if project.complete?
    processed_amount = BigDecimal.new(project.charges.processed.before(cut_off).sum(:total_with_fee_in_cents)) / 100
    balance = outstanding_amount - processed_amount - amount
    balance.negative? ? 0 : balance # When company pays more than was estimated
  end

  def current_cycle_date
    all_occurrences = occurrences
    all_occurrences.detect(&:future?) || all_occurrences.last
  end

  def previous_cycle_date
    all_occurrences = occurrences
    all_occurrences.reverse.detect(&:past?)
  end

  WEEKDAY_BUFFERS = Hash.new(1.day).merge(
    5 => 3.days, # Friday to Monday
    6 => 2.days, # Saturday to Monday
    0 => 1.day # Sunday to Monday
  ).freeze

  def calculate_process_at_date(date)
    process_at = project.fixed_pricing? ? date.to_date : date.to_date + WEEKDAY_BUFFERS[date.wday]
    process_at.in_time_zone(timezone).end_of_day
  end

  def timezone
    @_timezone ||= project.business.tz
  end
end
