# frozen_string_literal: true

FactoryGirl.define do
  factory :stripe_account do
    specialist
    dob Faker::Date.birthday(18, 95)
    tos_acceptance_date Time.zone.today
    tos_acceptance_ip '1.1.1.1'
  end
end
