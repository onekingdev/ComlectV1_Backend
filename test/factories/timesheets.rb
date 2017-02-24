# frozen_string_literal: true
FactoryGirl.define do
  factory :timesheet do
    transient do
      hours nil
    end

    project
    status Timesheet.statuses.fetch(:pending)

    before(:create) do |timesheet, evaluator|
      hours = evaluator.hours
      timesheet.time_logs.build description: 'Hours worked', hours: hours if hours
    end

    trait(:submitted) { status Timesheet.statuses.fetch(:submitted) }
    trait(:approved) { status Timesheet.statuses.fetch(:approved) }
  end
end
