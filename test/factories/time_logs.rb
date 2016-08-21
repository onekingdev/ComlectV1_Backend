# frozen_string_literal: true
FactoryGirl.define do
  factory :time_log do
    timesheet nil
    description "MyString"
    hours "9.99"
  end
end
