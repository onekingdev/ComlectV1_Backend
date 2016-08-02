# frozen_string_literal: true
FactoryGirl.define do
  factory :specialist do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
