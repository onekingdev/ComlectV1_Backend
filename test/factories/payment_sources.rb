# frozen_string_literal: true

FactoryGirl.define do
  factory :payment_source do
    payment_profile
    stripe_id 'dummy'
    brand 'visa'
    last4 '1234'
  end
end
