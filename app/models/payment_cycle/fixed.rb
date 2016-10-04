# frozen_string_literal: true
class PaymentCycle::Fixed < PaymentCycle
  def estimated_total
    project.fixed_budget
  end

  def create_charges!
    current_cycle = previous_cycle_date
    return if charge_exists?(current_cycle)
    remaining_dates = occurrences.reject { |date| charge_exists?(date) }
    amount = outstanding_amount / (remaining_dates.size * 1.0)
    schedule_charge! amount: amount,
                     date: current_cycle,
                     description: "Monthly pay"
  end
end
