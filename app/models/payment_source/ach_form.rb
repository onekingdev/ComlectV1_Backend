# frozen_string_literal: true

class PaymentSource::ACHForm < Draper::Decorator
  decorates PaymentSource::ACH
  delegate_all

  attr_accessor :routing_number, :account_number

  def self.new_for(business, attributes = {})
    profile = business.payment_profile || business.build_payment_profile
    defaults = { type: 'PaymentSource::ACH', country: 'US', currency: 'USD' }
    new profile.payment_sources.new(defaults.merge(attributes))
  end

  def self.find_for(business, id)
    new business.payment_sources.find(id)
  end
end
