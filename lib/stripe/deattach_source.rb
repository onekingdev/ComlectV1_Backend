# frozen_string_literal: true

module Stripe
  module DeattachSource
    def self.call(customer_stripe_id, stripe_source_id)
      Stripe::Customer.detach_source(customer_stripe_id, stripe_source_id)
    end
  end
end
