# frozen_string_literal: true
class StripeEvent::TransferFailed < StripeEvent
  def handle
    StripeMailer.deliver_later :transfer_failed, account.specialist.user.email
  end
end
