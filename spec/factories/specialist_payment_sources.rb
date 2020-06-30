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
end
