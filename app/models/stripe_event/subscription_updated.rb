# frozen_string_literal: true

class StripeEvent::SubscriptionUpdated < StripeEvent
  def handle
    sub = ForumSubscription.find_by(stripe_subscription_id: event.data.object.id)
    sub.update(renewal_date: event.data.object.current_period_end)
    Stripe::Invoice.create(
      customer: event.data.object.customer
    )
  end
end
