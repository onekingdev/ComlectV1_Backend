# frozen_string_literal: true

FactoryBot.define do
  factory :work_experience do
    transient do
      length 10.years
    end

    specialist
    company { Faker::Company.name }
    job_title { Faker::Company.profession }
    from { rand(40).years.ago + 10.years }
    to { from + length }

    trait :compliance do
      compliance true
    end

    trait :current do
      current true
    end
  end
end
