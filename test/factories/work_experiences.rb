# frozen_string_literal: true
FactoryGirl.define do
  factory :work_experience do
    specialist
    company { Faker::Company.name }
    job_title { Faker::Company.profession }
    from { rand(40).years.ago + 10.years }
  end
end
