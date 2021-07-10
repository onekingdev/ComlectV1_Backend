# frozen_string_literal: true

FactoryBot.define do
  factory :project_issue do
    project nil
    user nil
    issue 'MyText'
    desired_resolution 'MyText'
  end
end
