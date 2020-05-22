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
    plan_id = case plan.to_s.downcase
              when 'monthly' then ENV['STRIPE_SUB_CCC_MONTHLY']
              when 'annual' then ENV['STRIPE_SUB_CCC_ANNUAL']
              end
    return unless plan_id

    Stripe::Subscription.create(
      customer: customer_id,
      items: [
        plan: plan_id
      ]
    )
  end
end
