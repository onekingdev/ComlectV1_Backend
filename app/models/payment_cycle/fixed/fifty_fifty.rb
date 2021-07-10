# frozen_string_literal: true

class PaymentCycle::Fixed::FiftyFifty < PaymentCycle::Fixed
  def create_charges!
    # Create first real charge right away
    create_first_charge!

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

  def create_first_charge!
    return if charge_exists?(project.starts_on.in_time_zone(timezone))

    schedule_charge!(
      amount: estimated_total / 2.0,
      date: project.starts_on.in_time_zone(timezone),
      description: 'First 50/50 charge'
    )
  end

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
