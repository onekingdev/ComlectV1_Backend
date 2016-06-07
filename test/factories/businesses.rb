# frozen_string_literal: true
FactoryGirl.define do
  factory :business do
    contact_first_name { Faker::Name.first_name }
    contact_last_name { Faker::Name.last_name }
    contact_email { Faker::Internet.email }
    business_name { Faker::Company.name }
    industry { Faker::Company.industry }
    employees { 100 }
    description { Faker::Company.bs }
    country { Faker::Address.country }
    city { Faker::Address.city }
    state { Faker::Address.state }
  end
end
