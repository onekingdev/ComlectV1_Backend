# frozen_string_literal: true

FactoryBot.define do
  factory :specialist do
    association :user, email_prefix: 'specialist'
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    time_zone { Faker::Address.time_zone }

    trait :gold_rewards do
      rewards_tier 'gold'
    end

    trait :platinum_rewards do
      rewards_tier 'platinum'
    end

    trait :platinum_honors_rewards do
      rewards_tier 'platinum_honors'
    end
  end
end
