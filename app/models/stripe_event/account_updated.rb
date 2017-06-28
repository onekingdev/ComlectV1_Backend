# frozen_string_literal: true

class StripeEvent::AccountUpdated < StripeEvent
  def handle
    object = event.data.object
    return if object.verification.fields_needed.empty?
    stripe_account = Stripe::Account.retrieve(object.id)
    account = StripeAccount.find_by!(stripe_id: object.id)
    account.update_status_from_stripe stripe_account
    Notification::Deliver.payment_issue! account.specialist.user
  end
end
