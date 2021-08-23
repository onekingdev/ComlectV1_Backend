# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    kind_of 'ccc'
    status 'active'
    business_id nil
    payment_source nil
    plan 'business_tier_annual'
  end
end
