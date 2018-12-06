class StripeEvent::InvoiceCreated < StripeEvent
  def handle
    subscription_id = event.data.object.lines.data[0].id
    fs = ForumSubscription.find_by(:stripe_subscription_id => subscription_id)
    SubscriptionCharge.where(
      :forum_subscription => fs,
      :stripe_charge_id => event.data.object.charge,
      :stripe_subscription_id => subscription_id,
      :plan => event.data.object.lines.data[0].plan.id
    ).first_or_create
  end
end
