# frozen_string_literal: true
FactoryGirl.define do
  factory :time_log do
    timesheet
    description "Work well done"
    hours { rand(10) }
  end
end
