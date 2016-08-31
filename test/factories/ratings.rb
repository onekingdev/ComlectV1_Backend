# frozen_string_literal: true
FactoryGirl.define do
  factory :rating do
    project nil
    rater nil
    value 1
    review "MyString"
  end
end
