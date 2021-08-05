# frozen_string_literal: true

module StripeHelper
  def create_stripe_plans
    product = Stripe::Product.create(
      name: 'rspec_plans',
      type: 'service'
    )
    Stripe::Plan.create(
      id: ENV['STRIPE_SUB_SEATS_MONTHLY'],
      interval: 'month',
      currency: 'usd',
      amount: 1200,
      product: product.id
    )
    Stripe::Plan.create(
      id: ENV['STRIPE_SUB_SEATS_ANNUAL'],
      interval: 'year',
      currency: 'usd',
      amount: 12_000,
      product: product.id
    )
  rescue => e # Lint/HandleExceptions: disable
    ap e
  end
end
