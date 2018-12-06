class StripeEvent::SubscriptionCreated < StripeEvent
  def handle
    cust_id = event.data.object.customer
    subscription_id = event.data.object.items.data[0].subscription
    sub = ForumSubscription.find_by(:stripe_customer_id => cust_id)
    if sub
      sub.update_attributes(:stripe_subscription_id => subscription_id)
    end
  end
end
