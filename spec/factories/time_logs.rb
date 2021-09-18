# frozen_string_literal: true

FactoryBot.define do
  factory :time_log do
    timesheet
    description 'Work well done'
    date { Time.current }
    hours { rand(1..10) }
  end
end
