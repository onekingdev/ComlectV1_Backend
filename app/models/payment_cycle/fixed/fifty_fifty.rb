# frozen_string_literal: true
class PaymentCycle::Fixed::FiftyFifty < PaymentCycle::Fixed
  def reschedule!
    # Create first real charge right away
    unless charge_exists?(project.starts_on)
      schedule_charge! amount: estimated_total / 2.0, date: project.starts_on, description: "First 50/50 charge"
    end
    # Schedule second charge normally
    super
  end

  def create_charges!
    remaining_dates = occurrences.reject { |date| charge_exists?(date) }
    amount = outstanding_amount / (remaining_dates.size * 1.0)
    remaining_dates.each do |date|
      schedule_charge! amount: amount,
                       date: date,
                       description: charge_description
    end
  end

  private

  def charge_description
    "50/50 project payment"
  end

  def occurrences
    [project.starts_on, project.ends_on]
  end
end
