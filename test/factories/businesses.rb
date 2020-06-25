# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    association :user, email_prefix: 'business'
    # association :rewards_tier
    contact_first_name { Faker::Name.first_name }
    contact_last_name { Faker::Name.last_name }
    contact_email { Faker::Internet.email }
    business_name { Faker::Company.name }
    industries { [create(:industry)] }
    employees { Business::EMPLOYEE_OPTIONS.sample }
    risk_tolerance { Business::RISK_TOLERANCE_OPTIONS.sample }
    description { Faker::Company.bs }
    country { Faker::Address.country }
    city { Faker::Address.city }
    state { Faker::Address.state }
    time_zone 'Mountain Time (US & Canada)'
    client_account_cnt 123
    total_assets '20MM'

    sequence(:username) { |n| "UserN#{n + rand(10_000)}" }
    trait :with_payment_profile do
      after(:create) do |business, _evaluator|
        create(:payment_profile, business: business)
      end
    end

    trait :with_payment_profile_bank do
      after(:create) do |business, _evaluator|
        profile = business&.payment_profile || create(:payment_profile, business: business)
        profile.payment_sources.first.update(
          type: 'PaymentSource::ACH',
          brand: 'Chase',
          validated: true,
          primary: true
        )
      end
    end

    trait :credit do
      credits_in_cents 3000
    end

    trait :fee_free do
      fee_free true
    end
  end
end
