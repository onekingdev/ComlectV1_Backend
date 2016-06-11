# frozen_string_literal: true
FactoryGirl.define do
  factory :industry do
    name { Faker::Company.industry }
  end
end
