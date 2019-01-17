# frozen_string_literal: true

class StripeEvent::SubscriptionCreated < StripeEvent
  def handle
    cust_id = event.data.object.customer
    # "current_period_end"
    subscription_id = event.data.object.items.data[0].subscription
    sub = ForumSubscription.find_by(stripe_customer_id: cust_id)
    sub&.update(stripe_subscription_id: subscription_id)
  end
end
