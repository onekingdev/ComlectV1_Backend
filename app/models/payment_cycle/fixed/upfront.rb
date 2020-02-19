# frozen_string_literal: true

class PaymentCycle::Fixed::Upfront < PaymentCycle::Fixed
  def create_charges!
    return if charge_exists?(project.starts_on.in_time_zone(timezone))

    schedule_charge!(
      amount: estimated_total,
      date: project.starts_on.in_time_zone(timezone),
      description: 'Upfront charge'
    )
  end

  private

  def charge_description
    'Upfront project payment'
  end

  def occurrences
    [project.starts_on.in_time_zone(timezone)]
  end
end
