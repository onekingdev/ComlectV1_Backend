# frozen_string_literal: true

FactoryBot.define do
  factory :finding do
    annual_report_id 1
    finding 'MyText'
    action 'MyText'
    risk_lvl 1
  end
end
