# frozen_string_literal: true

FactoryGirl.define do
  factory :job_application do
    specialist
    project
    message 'I work good'
  end
end
