# frozen_string_literal: true

FactoryBot.define do
  factory :feedback_request do
    name 'MyString'
    email 'MyString'
    phone 'MyString'
    specialists 'MyString'
    budget 'MyString'
    description 'MyText'
    ip ''
    user_agent 'MyString'
    kind 'MyString'
  end
end
