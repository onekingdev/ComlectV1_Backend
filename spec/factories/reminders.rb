# frozen_string_literal: true

FactoryBot.define do
  factory :reminder do
    body 'MyString'
    business_id 1
    remind_at '2019-11-06'
  end
end
