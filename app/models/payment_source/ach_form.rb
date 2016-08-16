# frozen_string_literal: true
class PaymentSource::ACHForm < Draper::Decorator
  decorates PaymentSource::ACH
  delegate_all

  attr_accessor :routing_number, :account_number

  def self.new_for(business)
    profile = business.payment_profile || business.build_payment_profile
    new profile.payment_sources.new(type: 'PaymentSource::ACH', country: 'US', currency: 'USD')
  end

  def self.find_for(business, id)
    new business.payment_sources.find(id)
  end
end
