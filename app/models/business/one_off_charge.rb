# frozen_string_literal: true

class Business::OneOffCharge
  attr_accessor :business

  def self.for(business)
    new.tap do |charge|
      charge.business = business
    end
  end

  def process!(amount_in_cents:, description:)
    raise 'Amount must be a positive integer' if amount_in_cents.negative?
    raise 'Payment profile required' if business.payment_profile.blank?

    Stripe::Charge.create(
      amount: amount_in_cents,
      currency: 'usd',
      description: description,
      customer: business.payment_profile.stripe_customer_id
    )
  end
end
