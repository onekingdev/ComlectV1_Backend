# frozen_string_literal: true

FactoryGirl.define do
  factory :transaction do
    stripe_id "MyString"
    amount_in_cents 10_000
    status Transaction.statuses[:pending]
  end
end
