# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    thread nil
    sender nil
    recipient nil
    message 'MyString'
    file_data ''
  end
end
