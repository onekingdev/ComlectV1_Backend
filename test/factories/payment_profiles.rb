# frozen_string_literal: true

FactoryBot.define do
  factory :payment_profile do
    business

    after(:create) do |payment_profile, _evaluator|
      create(:payment_source, payment_profile: payment_profile)
    end
  end
end
