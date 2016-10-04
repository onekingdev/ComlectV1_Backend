# frozen_string_literal: true
class PaymentCycle::Hourly::UponCompletion < PaymentCycle::Hourly
  def reschedule!
    project.charges.estimated.delete_all
    date = occurrences.first
    return if charge_exists?(date)
    create_estimated_charge! amount: outstanding_amount, date: date
  end

  def occurrences
    [project.ends_on]
  end
end
