# frozen_string_literal: true

class Business::PaymentSourceSerializer < ApplicationSerializer
  attributes :id,
             :payment_profile_id,
             :stripe_id,
             :brand,
             :exp_month,
             :exp_year,
             :last4,
             :primary,
             :type,
             :country,
             :currency,
             :account_holder_name,
             :account_holder_type,
             :validated,
             :coupon_id
end
