# frozen_string_literal: true

FactoryBot.define do
  factory :payment_profile do
    business
  end

  factory :payment_profile_with_source, parent: :payment_profile do
    stripe_customer_id 'stripe_customer_id'

    after(:create) do |payment_profile|
      create(:payment_source, payment_profile: payment_profile)
    end
  end

  factory :payment_profile_with_stripe_customer, parent: :payment_profile do
    after(:create) do |payment_profile, _evaluator|
      cus = Stripe::Customer.create

      payment_profile.update(stripe_customer_id: cus&.id)

      create(:payment_source, payment_profile: payment_profile)
    end
  end
end
