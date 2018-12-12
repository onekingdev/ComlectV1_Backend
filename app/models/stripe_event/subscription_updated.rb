# frozen_string_literal: true

class StripeEvent::SubscriptionUpdated < StripeEvent
  def handle
    Stripe::Invoice.create(
      customer: event.data.object.customer
    )
  end
end
