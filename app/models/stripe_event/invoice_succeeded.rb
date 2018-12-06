class StripeEvent::InvoiceSucceeded < StripeEvent
  def handle
    sub = SubscriptionCharge.find_by(:stripe_charge_id => event.data.object.charge)
    fs_id = ForumSubscription.where(:stripe_subscription_id => subscription_id).first.pluck(:id)
    if sub
      sub.update_attributes(:forum_subscription_id => fs_id, :status => 1)
    end
  end
end
