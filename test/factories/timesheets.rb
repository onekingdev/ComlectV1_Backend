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

      if hours
        timesheet.time_logs << build(
          :time_log,
          hours: hours,
          timesheet: timesheet
        )
      end
    end

    trait(:submitted) { status Timesheet.statuses.fetch(:submitted) }
    trait(:approved) { status Timesheet.statuses.fetch(:approved) }
    trait(:disputed) { status Timesheet.statuses.fetch(:disputed) }
  end
end
