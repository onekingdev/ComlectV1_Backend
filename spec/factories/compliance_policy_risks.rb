# frozen_string_literal: true

FactoryBot.define do
  factory :compliance_policy_risk do
    name 'MyString'
    level 1
    description 'MyText'
    compliance_policy_id 1
  end
end
