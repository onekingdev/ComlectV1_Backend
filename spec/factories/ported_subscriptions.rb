# frozen_string_literal: true

FactoryBot.define do
  factory :ported_subscription do
    specialist_id 1
    business_id 1
    period ''
    subscribed_at '2020-06-30 17:33:58'
    billing_period_ends '2020-06-30 17:33:58'
    stripe_subscription_id 'MyText'
  end
end
