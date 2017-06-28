# frozen_string_literal: true

class PaymentCycle::FullTime < PaymentCycle
  def outstanding_amount
    0
  end
end
