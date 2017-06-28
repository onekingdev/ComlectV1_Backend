# frozen_string_literal: true

FactoryGirl.define do
  factory :charge do
    project nil
    amount "9.99"
    process_after "2016-09-01 12:59:40"
    status "MyString"
    payment_source nil
    description "MyString"
  end
end
