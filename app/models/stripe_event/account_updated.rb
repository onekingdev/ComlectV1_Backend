# frozen_string_literal: true

# rubocop:disable Metrics/AbcSize
class StripeEvent::AccountUpdated < StripeEvent
  def handle
    object = event.data.object
    return if object.legal_entity.verification.status == 'verified'
    return if object.legal_entity.verification.document.nil?
    stripe_account = Stripe::Account.retrieve(object.id)
    account = StripeAccount.find_by!(stripe_id: object.id)
    account.update_status_from_stripe stripe_account
    Notification::Deliver.payment_issue! account.specialist.user
  end
end
# rubocop:enable Metrics/AbcSize
