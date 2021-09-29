# frozen_string_literal: true

FactoryBot.define do
  factory :specialist_payment_source, class: 'Specialist::PaymentSource' do
    specialist_id 1
    stripe_customer_id 'MyText'
    stripe_card_id 'MyText'
    brand 'MyText'
    exp_month 1
    exp_year 1
    last4 'MyText'
    primary false
  end

  factory :specialist_payment_source_primary, class: 'Specialist::PaymentSource' do
    specialist_id 1
    stripe_customer_id 'stripe_customer_id'
    stripe_card_id 'stripe_card_id'
    brand 'Visa'
    exp_month 12
    exp_year 2022
    last4 '4242'
    primary true
    validated true
    bank_account false
  end
end
