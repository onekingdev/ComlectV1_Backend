# frozen_string_literal: true

FactoryBot.define do
  factory :payment_source do
    # stripe_id 'dummy'
    sequence(:stripe_id) { |n| "dummy_#{n + rand(10_000)}" }
    brand 'visa'
    last4 '1234'
  end
end
