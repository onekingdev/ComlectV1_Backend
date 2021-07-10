# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    user nil
    message 'MyString'
    read_at '2016-08-24 15:20:48'
  end
end
