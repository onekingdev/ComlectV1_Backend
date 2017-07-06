# frozen_string_literal: true

FactoryGirl.define do
  factory :payment_source do
    stripe_id 'dummy'
    brand 'visa'
    last4 '1234'
  end
end
