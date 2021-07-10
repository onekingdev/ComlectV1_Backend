# frozen_string_literal: true

class PaymentSource::AchForm < Draper::Decorator
  decorates PaymentSource::Ach
  delegate_all

  attr_accessor :routing_number, :account_number

  def self.new_for(business, attributes = {})
    profile = business.payment_profile || business.build_payment_profile
    defaults = { type: 'PaymentSource::Ach', country: 'US', currency: 'USD' }
    new profile.payment_sources.new(defaults.merge(attributes))
  end

  def self.find_for(business, id)
    new business.payment_sources.find(id)
  end
end
