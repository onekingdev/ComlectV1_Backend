# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    association :user, email_prefix: 'business'
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

    trait :with_payment_profile do
      after(:create) do |business, _evaluator|
        create(:payment_profile, business: business)
      end
    end

    trait :fee_free do
      fee_free true
    end
  end
end
