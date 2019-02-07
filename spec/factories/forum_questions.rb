# frozen_string_literal: true

FactoryBot.define do
  factory :forum_question do
    title 'MyString'
    body 'MyText'
    state 'MyString'
    business_id 1
  end
end
