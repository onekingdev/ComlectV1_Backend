class StripeEvent::InvoiceCreated < StripeEvent
  def handle
    subscription_id = event.data.object.lines.data[0].id
    fs_id = ForumSubscription.where(:stripe_subscription_id => subscription_id).first.pluck(:id)
    SubscriptionCharge.where(
      :forum_subscription_id => fs_id,
      :stripe_charge_id => event.data.object.charge,
      :stripe_subscription_id => subscription_id,
      :plan => event.data.object.lines.data[0].plan.id
    ).first_or_create
  end
end
