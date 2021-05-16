# frozen_string_literal: true

FactoryBot.define do
  factory :exam_request do
    name 'MyString'
    details 'MyText'
    text_items ''
    complete false
    shared false
  end
end
