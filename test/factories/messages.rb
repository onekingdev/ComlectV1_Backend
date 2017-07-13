# frozen_string_literal: true

FactoryGirl.define do
  factory :message do
    thread nil
    sender nil
    recipient nil
    message 'MyString'
    file_data ''
  end
end
