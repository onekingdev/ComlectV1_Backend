# frozen_string_literal: true

FactoryBot.define do
  factory :payment_profile do
    business

    after(:create) do |payment_profile, _evaluator|
      cus = Stripe::Customer.create

      payment_profile.update(stripe_customer_id: cus&.id)

      create(:payment_source, payment_profile: payment_profile)
    end
  end
end
