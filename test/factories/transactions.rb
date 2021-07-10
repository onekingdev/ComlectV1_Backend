# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    stripe_id 'MyString'
    amount_in_cents 10_000
    status Transaction.statuses[:pending]

    trait :pending do
      status Transaction.statuses[:pending]
    end

    trait :processed do
      status Transaction.statuses[:processed]
      processed_at Time.zone.now
    end
  end
end
