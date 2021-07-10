# frozen_string_literal: true

class StripeEvent::SubscriptionCreated < StripeEvent
  def handle
    cust_id = event.data.object.customer
    end_date = Time.at(event.data.object.current_period_end.to_i).utc
    subscription_id = event.data.object.id
    sub = ForumSubscription.find_by(stripe_customer_id: cust_id)
    sub&.update(stripe_subscription_id: subscription_id, renewal_date: end_date, cancelled: false, suspended: false)
  end
end
