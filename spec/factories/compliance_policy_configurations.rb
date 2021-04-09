# frozen_string_literal: true

FactoryBot.define do
  factory :compliance_policy_configuration do
    business_id 1
    logo_data ''
    address false
    phone false
    email false
    disclosure false
    body 'MyText'
  end
end
