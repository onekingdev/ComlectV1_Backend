# frozen_string_literal: true
FactoryGirl.define do
  factory :transaction do
    stripe_id "MyString"
    amount_in_cents 1
    processed_at "2016-09-29 13:17:28"
  end
end
