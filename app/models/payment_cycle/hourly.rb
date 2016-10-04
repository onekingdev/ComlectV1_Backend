# frozen_string_literal: true
class PaymentCycle::Hourly < PaymentCycle
  def estimated_total
    project.estimated_hours * project.hourly_rate
  end
end
