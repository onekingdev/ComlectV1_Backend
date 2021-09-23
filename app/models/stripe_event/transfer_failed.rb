# frozen_string_literal: true

class StripeEvent::TransferFailed < StripeEvent
  def handle; end

  # def handle
  #   Notification::Deliver.payment_issue! account.specialist.user
  # end
end
