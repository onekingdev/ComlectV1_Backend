# frozen_string_literal: true

class StripeEvent::ChargeFailed < StripeEvent
  def handle
    payment_profile = PaymentProfile.find_by(stripe_customer_id: event.data.object.customer)
    unless payment_profile.failed
      payment_profile.update(failed: true)
      Notification::Deliver.payment_issue! payment_profile.business.user
    end
    transaction = Transaction.where(stripe_id: event.data.object.id)
    subscription = SubscriptionCharge.where(stripe_charge_id: event.data.object.id)
    if transaction.count.positive?
      transaction.first.error!
      transaction.first.update_attribute :status_detail, event.data.object.failure_message
    elsif subscription.count.positive?
      subscription.first.failed!
      subscription.first.forum_subscription.update_attribute(suspended: true)
      # subscription.forum_subscription.business.update_attribute(qna_lvl: 0)
    end
  end
end
