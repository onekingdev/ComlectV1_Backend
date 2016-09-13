# frozen_string_literal: true
FactoryGirl.define do
  factory :specialist do
    user
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    time_zone { Faker::Address.time_zone }
  end
end
