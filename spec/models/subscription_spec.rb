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

    before {
      create_stripe_plans
      @coupon = Stripe::Coupon.create(
        percent_off: 25,
        duration: 'repeating',
        duration_in_months: 3
      )
    }

    context 'when ccc subscription' do
      it 'creates sub' do
        res = described_class.subscribe('monthly', business.payment_profile.stripe_customer)

        expect(res.status).to eq('active')
      end
    end

    context 'monthly subscription when no coupon' do
      it 'creates a stripe subscription without coupon' do
        subscription = described_class.subscribe('monthly', business.payment_profile.stripe_customer, {})
        expect(subscription.object).to eq('subscription')
      end
    end

    context 'monthly subscription when coupon discount available' do
      it 'creates a stripe subscription with coupon' do
        subscription = described_class.subscribe('monthly', business.payment_profile.stripe_customer, {}, @coupon.id)
        expect(subscription.discount.coupon.id).to eq(@coupon.id)
      end
    end

    context 'Annual subscription when no coupon' do
      it 'creates a stripe subscription without coupon' do
        subscription = described_class.subscribe('annual', business.payment_profile.stripe_customer, {})
        expect(subscription.object).to eq('subscription')
      end
    end

    context 'Annual subscription when coupon discount available' do
      it 'creates a stripe subscription with coupon' do
        subscription = described_class.subscribe('annual', business.payment_profile.stripe_customer, {}, @coupon.id)
        expect(subscription.discount.coupon.id).to eq(@coupon.id)
      end
    end

    context 'Seats monthly subscription when no coupon' do
      it 'creates a stripe subscription without coupon' do
        subscription = described_class.subscribe('seats_monthly', business.payment_profile.stripe_customer, {})
        expect(subscription.object).to eq('subscription')
      end
    end

    context 'Seats monthly subscription when coupon discount available' do
      it 'creates a stripe subscription with coupon' do
        subscription = described_class.subscribe('seats_monthly', business.payment_profile.stripe_customer, {}, @coupon.id)
        expect(subscription.discount.coupon.id).to eq(@coupon.id)
      end
    end

    context 'Seats Annual subscription when no coupon' do
      it 'creates a stripe subscription without coupon' do
        subscription = described_class.subscribe('seats_annual', business.payment_profile.stripe_customer, {})
        expect(subscription.object).to eq('subscription')
      end
    end

    context 'Seats Annual subscription when coupon discount available' do
      it 'creates a stripe subscription with coupon' do
        subscription = described_class.subscribe('seats_annual', business.payment_profile.stripe_customer, {}, @coupon.id)
        expect(subscription.discount.coupon.id).to eq(@coupon.id)
      end
    end
  end
end
