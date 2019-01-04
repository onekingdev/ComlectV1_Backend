# frozen_string_literal: true

class StripeEvent::SubscriptionCancelled < StripeEvent
  def handle
    fs = ForumSubscription.find_by(stripe_subscription_id: event.data.object.items.data[0].subscription)
    fs.business.update(qna_lvl: 0)
    fs.update(suspended: true)
  end
end
