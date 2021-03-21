# frozen_string_literal: true

module Stripe
  module CancelSubscription
    def self.call(stripe_subscription_id)
      Stripe::Subscription.delete(stripe_subscription_id)
    end
  end
end
