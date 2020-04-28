# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    association :user, email_prefix: 'business'
    association :rewards_tier
    contact_first_name { Faker::Name.first_name }
    contact_last_name { Faker::Name.last_name }
    contact_email { Faker::Internet.email }
    business_name { Faker::Company.name }
    industries { [create(:industry)] }
    employees { Business::EMPLOYEE_OPTIONS.sample }
    description { Faker::Company.bs }
    country { Faker::Address.country }
    city { Faker::Address.city }
    state { Faker::Address.state }
    time_zone 'Mountain Time (US & Canada)'
    sequence(:username) { |n| "UserN#{n + rand(10_000)}" }
    trait :with_payment_profile do
      after(:create) do |business, _evaluator|
        create(:payment_profile, business: business)
      end
    end

    trait :credit do
      credits_in_cents 3000
    end

    trait :fee_free do
      fee_free true
    end

    trait :gold_rewards do
      association :rewards_tier, factory: %i[rewards_tier gold]
    end

    trait :platinum_rewards do
      association :rewards_tier, factory: %i[rewards_tier platinum]
    end

    trait :platinum_honors_rewards do
      association :rewards_tier, factory: %i[rewards_tier platinum_honors]
    end

    trait :gold_rewards_override do
      association :rewards_tier_override, factory: %i[rewards_tier gold]
    end

    trait :platinum_rewards_override do
      association :rewards_tier_override, factory: %i[rewards_tier platinum]
    end

    trait :platinum_honors_rewards_override do
      association :rewards_tier_override, factory: %i[rewards_tier platinum_honors]
    end
  end
end
