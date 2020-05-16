# frozen_string_literal: true

FactoryBot.define do
  factory :payment_source do
    stripe_id 'dummy'
    brand 'visa'
    last4 '1234'
  end
end
