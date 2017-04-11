# frozen_string_literal: true
FactoryGirl.define do
  factory :work_experience do
    transient do
      length 10.years
    end

    specialist
    company { Faker::Company.name }
    job_title { Faker::Company.profession }
    from { rand(40).years.ago + 10.years }
    to { from + length }
  end
end
