# frozen_string_literal: true

class StripeEvent::ChargeFailed < StripeEvent
  def handle
    transaction = Transaction.find_by!(stripe_id: event.data.object.id)
    subscription = SubscriptionCharge.find_by!(stripe_charge_id: event.data.object.id)
    if transaction
      transaction.error!
      transaction.update_attribute :status_detail, event.data.object.failure_message
      Notification::Deliver.payment_issue! transaction.business.user
    elsif subscription
      subscription.forum_subscription.update_attribute(suspended: true)
      subscription.forum_subscription.business.update_attribute(qna_lvl: 0)
    end
  end
end
