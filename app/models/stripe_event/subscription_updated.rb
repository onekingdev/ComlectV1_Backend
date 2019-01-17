# frozen_string_literal: true

class StripeEvent::SubscriptionUpdated < StripeEvent
  def handle
    Stripe::Invoice.create(
      # "current_period_end"
      customer: event.data.object.customer
    )
  end
end
