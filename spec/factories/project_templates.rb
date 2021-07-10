# frozen_string_literal: true

FactoryBot.define do
  factory :project_template do
    title 'MyString'
    type ''
    location_type 'MyString'
    description 'MyString'
    payment_schedule 'MyString'
    fixed_budget '9.99'
    hourly_rate '9.99'
    estimated_hours 1
    only_regulators false
    annual_salary 1
    fee_type 'MyString'
    minimum_experience 1
    duration_type 'MyString'
    estimated_days 1
  end
end
