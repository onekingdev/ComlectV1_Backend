# frozen_string_literal: true

class StripeEvent::InvoiceCreated < StripeEvent
  def handle
    stripe = event.data.object
    fs = PaymentProfile.find_by(stripe_customer_id: stripe.customer).business.forum_subscription
    sub = SubscriptionCharge.where(forum_subscription: fs, stripe_charge_id: stripe.charge).first_or_create if stripe.charge
    sub&.update(
      stripe_subscription_id:  stripe.lines.data[0].id,
      plan: stripe.lines.data[0].plan.id,
      amount: stripe.amount_paid
    )
  end
end
