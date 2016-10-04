# frozen_string_literal: true
FactoryGirl.define do
  factory :timesheet do
    project
    status { Timesheet.statuses.fetch(:pending) }
  end
end
