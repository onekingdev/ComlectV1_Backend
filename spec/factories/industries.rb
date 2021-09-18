# frozen_string_literal: true

FactoryBot.define do
  factory :industry do
    name { Faker::Company.industry }
  end
end
