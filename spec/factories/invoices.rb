# frozen_string_literal: true

FactoryBot.define do
  factory :invoice do
    price 100
    currency 'usd'
    date Time.zone.now
    name 'Invoice name'
    invoice_pdf 'invoice_pdf_url'
    stripe_invoice_id 'stripe_invoice_id'
    hosted_invoice_url 'hosted_invoice_url'
    stripe_customer_id 'stripe_customer_id'
  end
end
