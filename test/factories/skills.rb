# frozen_string_literal: true
FactoryGirl.define do
  factory :skill do
    name { Faker::Company.profession }
  end
end
