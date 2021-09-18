# frozen_string_literal: true

FactoryBot.define do
  factory :job_application do
    specialist
    project
    message 'I work good'

    trait :rfp do
      message 'This is my proposal'
      key_deliverables 'reports'
    end
  end
end
