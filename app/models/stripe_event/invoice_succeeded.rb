# frozen_string_literal: true

class StripeEvent::InvoiceSucceeded < StripeEvent
  def handle
    return if event.data.object.charge.nil?
    fs = PaymentProfile.find_by(stripe_customer_id: event.data.object.customer).business.forum_subscription
    sub = SubscriptionCharge.where(stripe_charge_id: event.data.object.charge, forum_subscription: fs).first_or_create
    sub.update(forum_subscription: fs, status: 1, amount: event.data.object.amount_paid)
    # fs.business.update(qna_lvl: fs[:level])
  end
end
