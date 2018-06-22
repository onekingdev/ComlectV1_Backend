# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    business
    status 'draft'
    title 'A Job'
    industry_ids { [create(:industry).id] }
    jurisdiction_ids { [create(:jurisdiction).id] }
    description 'Job description'
    minimum_experience Project::MINIMUM_EXPERIENCE.first.last

    factory :project_one_off do
      type Project.types[:one_off]
      location_type Project.location_types[:remote]
      starts_on { 1.month.from_now }
      ends_on { 1.month.from_now + 1.month }
      key_deliverables 'Key deliverables'
      payment_schedule 'monthly'
      estimated_hours 50

      factory :project_one_off_hourly do
        pricing_type 'hourly'
        payment_schedule 'monthly'
        hourly_rate 100
      end

      factory :project_one_off_fixed do
        pricing_type 'fixed'
        fixed_budget 10_000
        payment_schedule 'monthly'
      end
    end

    factory :project_full_time do
      type Project.types[:full_time]
      location 'Texas, USA'
      starts_on { 1.month.from_now }
      annual_salary 98_000
    end

    trait :monthly_pay do
      payment_schedule Project.payment_schedules[:monthly]
    end

    trait :upon_completion_pay do
      payment_schedule Project.payment_schedules[:upon_completion]
    end

    trait :fifty_fifty_pay do
      payment_schedule Project.payment_schedules[:fifty_fifty]
    end

    trait :published do
      status Project.statuses[:published]
    end

    trait :complete do
      status Project.statuses[:complete]
    end

    trait :upfront_fee do
      fee_type Project.fee_types[:upfront_fee]
    end

    trait :monthly_fee do
      fee_type Project.fee_types[:monthly_fee]
    end
  end
end
