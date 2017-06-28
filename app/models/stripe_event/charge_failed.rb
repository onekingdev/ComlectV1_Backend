# frozen_string_literal: true

class StripeEvent::ChargeFailed < StripeEvent
  def handle
    transaction = Transaction.find_by!(stripe_id: event.data.object.id)
    transaction.error!
    transaction.update_attribute :status_detail, event.data.object.failure_message
    Notification::Deliver.payment_issue! transaction.business.user
  end
end
