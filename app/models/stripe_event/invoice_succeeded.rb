# frozen_string_literal: true

class StripeEvent::InvoiceSucceeded < StripeEvent
  def handle
    sub = SubscriptionCharge.find_by(stripe_charge_id: event.data.object.charge)
    fs = ForumSubscription.find_by(stripe_subscription_id: event.data.object.lines.data[0].id)
    sub&.update(forum_subscription: fs, status: 1)
  end
end
