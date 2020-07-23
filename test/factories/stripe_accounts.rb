# frozen_string_literal: true

FactoryBot.define do
  factory :stripe_account do
    specialist
    dob Faker::Date.birthday(min_age: 18, max_age: 95)
    tos_acceptance_date Time.zone.today
    tos_acceptance_ip '1.1.1.1'
  end
end
