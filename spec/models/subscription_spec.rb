# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  describe '.get_plan_id' do
    it 'when monthly' do
      expect(described_class.get_plan_id('monthly')).to eq(ENV['STRIPE_SUB_CCC_MONTHLY'])
    end

    it 'when annual' do
      expect(described_class.get_plan_id('annual')).to eq(ENV['STRIPE_SUB_CCC_ANNUAL'])
    end

    it 'when seats monthly' do
      expect(described_class.get_plan_id('seats_monthly')).to eq(ENV['STRIPE_SUB_SEATS_MONTHLY'])
    end

    it 'when seats annual' do
      expect(described_class.get_plan_id('seats_annual')).to eq(ENV['STRIPE_SUB_SEATS_ANNUAL'])
    end
  end

  describe '.subscribe' do
    let(:business) { create(:business, :with_payment_profile) }

    before { create_stripe_plans }

    context 'when ccc subscription' do
      it 'creates sub' do
        res = described_class.subscribe('monthly', business.payment_profile.stripe_customer)

        expect(res.status).to eq('active')
      end
    end

    context 'when seats subscription' do
      it 'creates sub' do
        # pending('stripe-ruby-mock does not support it yet')
        # res = described_class.subscribe(
        #   'seats_monthly',
        #   business.payment_profile.stripe_customer,
        #   quantity: 1,
        #   period_ends: (Time.now.utc + 1.year).to_i
        # )
        #
        # aggregate_failures do
        #   expect(res.status).to eq('active')
        #   expect(res.items.data[0].quantity).to eq(4)
        # end
      end
    end
  end
end
