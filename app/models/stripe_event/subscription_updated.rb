# frozen_string_literal: true

class StripeEvent::SubscriptionUpdated < StripeEvent
  def handle
    sub = ForumSubscription.find_by(stripe_subscription_id: event.data.object.id)
    end_date = Time.at(event.data.object.current_period_end.to_i).utc
    sub&.update(renewal_date: end_date)
    begin
      Stripe::Invoice.create(
        customer: event.data.object.customer
      )
    rescue StandardError => e
      Rails.logger.info e
    end
  end
end
