# frozen_string_literal: true

FactoryBot.define do
  factory :referral_token do
    association :referrer, factory: :specialist
    amount_in_cents 1000
    token SecureRandom.hex(3).upcase
  end
end
