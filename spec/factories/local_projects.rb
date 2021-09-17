# frozen_string_literal: true

FactoryBot.define do
  factory :local_project do
    business_id 1
    title 'MyString'
    description 'MyText'
    starts_on '2021-01-28 08:06:45'
    ends_on '2021-01-28 08:06:45'
    status 'MyString'
  end
end
