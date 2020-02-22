# frozen_string_literal: true

FactoryBot.define do
  factory :regulatory_change do
    annual_report_id 1
    change 'MyText'
    response 'MyText'
  end
end
