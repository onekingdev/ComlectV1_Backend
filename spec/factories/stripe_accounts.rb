# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_account do
    country 'US'
    specialist
    dob Faker::Date.birthday(min_age: 18, max_age: 95)
    tos_acceptance_date Time.zone.today
    tos_acceptance_ip '1.1.1.1'
  end

  factory :individual_stripe_account, parent: :stripe_account do
    last_name Faker::Name.last_name
    first_name Faker::Name.first_name
  end

  factory :company_stripe_account, parent: :stripe_account do
    account_type 'company'
    business_name Faker::Company.name
  end
end
