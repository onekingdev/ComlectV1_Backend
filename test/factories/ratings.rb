# frozen_string_literal: true

FactoryBot.define do
  factory :rating do
    project nil
    rater nil
    value 1
    review 'MyString'
  end
end
