# frozen_string_literal: true

class PaymentCycle::Fixed::FiftyFifty < PaymentCycle::Fixed
  def reschedule!
    # Create first real charge right away
    unless charge_exists?(project.starts_on.in_time_zone(timezone))
      schedule_charge!(
        amount: estimated_total / 2.0,
        date: project.starts_on.in_time_zone(timezone),
        description: 'First 50/50 charge'
      )
    end

    # Schedule second charge normally
    super
  end

  def create_charges!
    current_cycle = previous_cycle_date

    current_cycle = project.ends_on.in_time_zone(timezone) if project.complete?
    return unless current_cycle
    return if charge_exists?(current_cycle)

    schedule_charge!(
      amount: outstanding_amount,
      date: current_cycle,
      description: charge_description
    )
  end

  private

  def charge_description
    '50/50 project payment'
  end

  def occurrences
    [
      project.starts_on.in_time_zone(timezone),
      project.ends_on.in_time_zone(timezone)
    ]
  end
end
