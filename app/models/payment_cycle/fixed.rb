# frozen_string_literal: true

class PaymentCycle::Fixed < PaymentCycle
  def estimated_total
    project.fixed_budget
  end

  def create_charges!
    current_cycle = previous_cycle_date

    return unless current_cycle
    current_cycle = project.ends_on.in_time_zone(timezone) if project.complete?
    return if charge_exists?(current_cycle)

    amount = amount_for(current_cycle)
    return if amount.nil? || amount.zero?

    schedule_charge!(
      amount: amount,
      date: current_cycle,
      description: charge_description
    )
  end

  private

  def amount_for_day_period(date)
    return last_period_amount if last_period?(date - 1)
    days = days_for_period(date)
    (days * amount_per_day_remaining).round(2)
  end

  def total_days
    # Range should be inclusive
    project.ends_on - project.starts_on + 1
  end

  def remaining_days
    outstanding_occurrences.map { |date| days_for_period date }.reduce(:+)
  end

  def amount_per_day_remaining
    BigDecimal(outstanding_amount) / remaining_days
  end

  def days_for_period(date)
    date = date.to_date - 1
    period = periods.detect { |span| span.include?(date) }
    return 1 unless period
    (period.last - period.first).to_i + 1
  end

  def last_period_amount
    # Because of rounding, use a different method to return the last amount
    previous = outstanding_occurrences[0..-2].map do |date|
      days = days_for_period(date)
      (days * amount_per_day_remaining).round(2)
    end.reduce(:+) || 0

    outstanding_amount - previous
  end

  def last_period?(date)
    periods.last.include?(date.to_date)
  end

  def periods
    return @_periods if @_periods
    previous = project.starts_on
    last = occurrences.last.to_date

    @_periods = occurrences.map do |occurrence|
      date = occurrence.to_date
      adjust = date == last ? 0 : -1
      (previous..date + adjust).tap do
        previous = date + adjust + 1
      end
    end
  end
end
