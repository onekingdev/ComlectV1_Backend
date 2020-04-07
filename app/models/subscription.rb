# frozen_string_literal: true

class Subscription < ActiveRecord::Base
  belongs_to :business

  enum plan: %w[monthly annual]

  # unsure stripe customer business.payment_profile.stripe_customer
  # create one-time payment via InvoiceItem to customer
  # create subscription

  def self.create_invoice_item(customer_id)
    Stripe::InvoiceItem.create(
      amount: 50_000,
      currency: 'usd',
      customer: customer_id,
      description: 'On-boarding fee'
    )
  end

  def self.subscribe(plan, customer_id)
    Stripe::Subscription.create(
      customer: customer_id,
      items: [
        plan: "base_#{plan}"
      ]
    )
  end
end
