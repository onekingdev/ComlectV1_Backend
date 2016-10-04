# frozen_string_literal: true
class PaymentCycle::Fixed < PaymentCycle
  def estimated_total
    project.fixed_budget
  end
end
