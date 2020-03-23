# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Business::OneOffCharge do
  context 'when business has no payment profile' do
    let(:business) { create(:business) }

    it 'raises an error' do
      expect {
        Business::OneOffCharge.for(business).process!(amount_in_cents: 500, description: 'Widgets')
      }.to raise_error(RuntimeError)
    end
  end

  context 'when business has payment profile' do
    let(:business) { create(:business, :with_payment_profile) }

    context 'with negative amount' do
      it 'raises an error' do
        expect {
          Business::OneOffCharge.for(business).process!(amount_in_cents: -100, description: 'Widgets')
        }.to raise_error(RuntimeError)
      end
    end

    context 'with positive amount' do
      it 'returns a Stripe charge' do
        charge = Business::OneOffCharge.for(business).process!(amount_in_cents: 700, description: 'Widgets')
        expect(charge).to be_a(Stripe::Charge)
        expect(charge.amount).to eq 700
        expect(charge.status).to eq 'succeeded'
      end
    end
  end
end
