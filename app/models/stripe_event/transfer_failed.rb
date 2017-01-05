# frozen_string_literal: true
class StripeEvent::TransferFailed < StripeEvent
  def handle
    account = StripeAccount.find_by!(stripe_id: event.user_id)
    StripeMailer.deliver_later :transfer_failed, account.specialist.user.email
  end
end
