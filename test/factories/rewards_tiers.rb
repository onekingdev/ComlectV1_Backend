# frozen_string_literal: true

FactoryBot.define do
  factory :rewards_tier do
    name 'None'
    fee_percentage 0.10
    amount 0...9999

    trait :default do
      name 'None'
      fee_percentage 0.10
      amount 0...9999
    end

    trait :gold do
      name 'Gold'
      fee_percentage 0.08
      amount 10_000...50_000
    end

    trait :platinum do
      name 'Platinum'
      fee_percentage 0.07
      amount 50_001...100_000
    end

    trait :platinum_honors do
      name 'Platinum Honors'
      fee_percentage 0.06
      amount 100_001...1_000_000_000
    end
  end
end
