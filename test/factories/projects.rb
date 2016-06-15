# frozen_string_literal: true
FactoryGirl.define do
  factory :project do
    business
    type 'hourly'
    status 'draft'
    title 'A Job'
    location 'Remote'
    industries { [create(:industry)] }
    jurisdiction { [create(:jurisdiction)] }
    description 'Job description'
    key_deliverables 'Key deliverables'
    starts_on { 1.month.from_now }
    ends_on { starts_on + 1.month }
    pricing_type 'hourly'
    hourly_rate 100
    payment_schedule 'monthly'
    estimated_hours 50
  end
end
