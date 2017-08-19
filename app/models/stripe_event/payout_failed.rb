# frozen_string_literal: true

class StripeEvent::PayoutFailed < StripeEvent
  def handle
    object = event.data.object
    bank_account = BankAccount.find_by(stripe_id: object.destination)
    specialist = bank_account.stripe_account.specialist
    Notification::Deliver.payout_issue! specialist.user
  end
end
