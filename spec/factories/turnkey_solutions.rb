# frozen_string_literal: true

FactoryBot.define do
  factory :turnkey_solution do
    title 'MyString'
    range 'MyString'
    era false
    sma false
    fund false
    industries false
    jurisdictions false
    hours 1
    description 'MyText'
    features 'MyText'
    project_title 'MyString'
    project_type 'MyString'
    project_location_type 'MyString'
    project_location 'MyString'
    project_description 'MyString'
    project_payment_schedule 'MyString'
    project_fixed_budget '9.99'
    project_hourly_rate '9.99'
    project_estimated_hours 1
    project_only_regulators false
    project_annual_salary 1
    project_fee_type 'MyString'
    project_minimum_experience 1
    project_duration_type 'MyString'
    project_estimated_days 1
  end
end
