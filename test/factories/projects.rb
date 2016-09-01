# frozen_string_literal: true
FactoryGirl.define do
  factory :project do
    business
    status 'draft'
    title 'A Job'
    industry_ids { [create(:industry).id] }
    jurisdiction_ids { [create(:jurisdiction).id] }
    description 'Job description'

    factory :project_one_off do
      type Project.types[:one_off]
      location_type Project.location_types[:remote]
      starts_on { 1.month.from_now }
      ends_on { starts_on + 1.month }
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

    trait :published do
      status Project.statuses[:published]
    end

    trait :upfront_fee do
      fee_type Project.fee_types[:upfront_fee]
    end

    trait :monthly_fee do
      fee_type Project.fee_types[:monthly_fee]
    end
  end
end
