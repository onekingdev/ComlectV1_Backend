# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Specialist::PaymentSource, type: :model do
  let(:specialist) { create(:specialist) }
  let(:payment_source) { create(:specialist_payment_source) }
  let(:payment_source_primary) { create(:specialist_payment_source_primary) }

  it 'is valid with valid attributes' do
    expect(Specialist::PaymentSource.new).to be_valid
  end

  it 'should return false if payment source is not primary' do
    expect(payment_source.primary?).to be(false)
  end

  it 'should return false if payment source is  primary' do
    expect(payment_source_primary.primary?).to be(true)
  end

  it 'should able to make a payment source primary' do
    payment_source = specialist.payment_sources.where(primary: false).last
    payment_source.make_primary!
    expect(payment_source_primary.primary?).to be(true)
  end

  it 'should be able to validate bank account if source is bank account' do
    data = {
      validate1: 32,
      validate2: 45
    }
    @stripe_test_helper = StripeMock.create_test_helper
    customer = Stripe::Customer.create(email: specialist&.user&.email,
                                       name: specialist&.user&.full_name)
    bank = Stripe::Customer.create_source(customer.id, source: @stripe_test_helper.generate_bank_token)
    payment_source = specialist&.payment_sources&.create!(
        stripe_customer_id: customer.id,
        stripe_card_id: bank.id,
        last4: bank.last4,
        country: bank.country,
        brand: bank.bank_name,
        bank_account: true,
        currency: bank.currency,
        account_holder_name: bank.account_holder_name,
        account_holder_type: bank.account_holder_type,
        primary: specialist&.payment_sources&.length&.zero?
    )
    response = payment_source.validate_microdeposits(data)
    expect(response[:success]).to be(true)
  end

  it 'should not be able to validate  if source is not a bank account' do
    data = {
      validate1: 32,
      validate2: 88
    }
    @stripe_test_helper = StripeMock.create_test_helper
    customer = Stripe::Customer.create(email: specialist&.user&.email,
                                       name: specialist&.user&.full_name)
    card = Stripe::Customer.create_source(customer.id, source: @stripe_test_helper.generate_card_token)
    payment_source = specialist&.payment_sources&.create!(
        stripe_customer_id: customer.id,
        stripe_card_id: card.id,
        last4: card.last4,
        country: card.country,
        brand: card.brand,
        bank_account: false,
        primary: specialist&.payment_sources&.length&.zero?
    )
    response = payment_source.validate_microdeposits(data)
    expect(response[:success]).to be(false)
  end
end
