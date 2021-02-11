# frozen_string_literal: true

FactoryBot.define do
  factory :compliance_policy_section do
    compliance_policy_id 1
    parent_id 1
    name 'MyString'
    description 'MyText'
  end
end
