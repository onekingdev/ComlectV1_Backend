# frozen_string_literal: true

class PaymentProfile < ApplicationRecord
  belongs_to :business
  has_many :payment_sources, dependent: :destroy

  before_create :create_stripe_customer
  after_destroy :delete_stripe_data

  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id) if stripe_customer_id.present?
  end

  def update_default_source!
    source = payment_sources.find_by(stripe_id: stripe_customer.default_source)
    return if source.nil? || source.primary?
    payment_sources.update_all primary: false
    source.update_attribute :primary, true
  end

  private

  def create_stripe_customer
    customer = Stripe::Customer.create(description: business.business_name)
    self.stripe_customer_id = customer.id
  rescue Stripe::StripeError => e
    errors.add :base, e.message
  end

  def delete_stripe_data
    stripe_customer.delete if stripe_customer_id
  rescue StandardError => _e
    errors.add :base, 'Could not delete customer info'
    false
  end
end
