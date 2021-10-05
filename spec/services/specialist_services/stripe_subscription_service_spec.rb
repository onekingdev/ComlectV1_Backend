# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SpecialistServices::StripeSubscriptionService do
  let(:service) { SpecialistServices::StripeSubscriptionService.call(specialist, params) }

  describe 'call' do
    context 'plan name wrong' do
      let(:specialist) { create(:specialist) }

      context 'params empty' do
        let(:params) { {} }

        it { expect(service.success?).to be_falsey }
        it { expect(service.error).to eq('Wrong plan name') }
      end

      context 'fake plan' do
        let(:params) { { plan: 'fake' } }

        it { expect(service.success?).to be_falsey }
        it { expect(service.error).to eq('Wrong plan name') }
      end
    end

    context 'plan already subscribed' do
      let(:params) { { plan: 'specialist_pro' } }
      let(:specialist) { create(:specialist_with_pro_subscription) }
      let(:msg) { "You have already subscribed to 'All Access Membership'" }

      it { expect(service.success?).to be_falsey }
      it { expect(service.error).to eq(msg) }

      it { expect(service.instance_values['coupon_id']).to be_nil }
      it { expect(service.instance_values['success']).to be_falsey }
      it { expect(service.instance_values['payment_source']).to be_nil }
      it { expect(service.instance_values['stripe_customer']).to be_nil }
      it { expect(service.instance_values['plan']).to eq('specialist_pro') }
      it { expect(service.instance_values['specialist']).to eq(specialist) }
      it { expect(service.instance_values['active_subscription']).to eq(specialist.subscriptions.first) }
    end

    context 'subscribe free plan' do
      let(:params) { { plan: 'free' } }
      let(:specialist) { create(:specialist, dashboard_unlocked: false) }

      before do
        expect(specialist.dashboard_unlocked).to be_falsey
        expect(Subscription.count).to be_zero
        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(Subscription.count).to eq(1) }
      it { expect(specialist.dashboard_unlocked).to be_truthy }
      it { expect(specialist.subscriptions.first.plan).to eq('free') }
      it { expect(specialist.subscriptions.first.local).to be_truthy }
      it { expect(specialist.subscriptions.first.trial_end).to be_nil }
      it { expect(specialist.subscriptions.first.status).to eq('active') }
      it { expect(specialist.subscriptions.first.next_payment_date).to be_nil }

      it { expect(service.instance_values['plan']).to eq('free') }
      it { expect(service.instance_values['coupon_id']).to be_nil }
      it { expect(service.instance_values['success']).to be_truthy }
      it { expect(service.instance_values['subscription']).to be_present }
      it { expect(service.instance_values['specialist']).to eq(specialist) }
      it { expect(service.instance_values['active_subscription']).to be_nil }
    end

    context 'payment source missing' do
      let(:specialist) { create(:specialist) }
      let(:params) { { plan: 'specialist_pro' } }

      it { expect(service.success?).to be_falsey }
      it { expect(service.error).to eq('No payment source') }
    end

    context 'create pro subscription' do
      let(:params) { { plan: 'specialist_pro' } }
      let(:specialist) { create(:specialist_with_primary_payment_source, dashboard_unlocked: false) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_specialist_pro_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).with(
          'specialist_pro', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(specialist.dashboard_unlocked).to be_falsey
        expect(Subscription.count).to be_zero
        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(Subscription.count).to eq(1) }
      it { expect(specialist.dashboard_unlocked).to be_truthy }
      it { expect(specialist.subscriptions.first.local).to be_falsey }
      it { expect(specialist.subscriptions.first.trial_end).to be_nil }
      it { expect(specialist.subscriptions.first.status).to eq('active') }
      it { expect(specialist.subscriptions.first.plan).to eq('specialist_pro') }

      it { expect(specialist.subscriptions.first.amount).to eq(0.4e5) }
      it { expect(specialist.subscriptions.first.currency).to eq('usd') }
      it { expect(specialist.subscriptions.first.interval).to eq('year') }
      it { expect(specialist.subscriptions.first.billing_period_ends).to be_nil }
      it { expect(specialist.subscriptions.first.next_payment_date).to be_present }
      it { expect(specialist.subscriptions.first.stripe_subscription_id).to eq('stripe_subscription_id') }

      it { expect(service.instance_values['coupon_id']).to be_nil }
      it { expect(service.instance_values['success']).to be_truthy }
      it { expect(service.instance_values['plan']).to eq('specialist_pro') }
      it { expect(service.instance_values['specialist']).to eq(specialist) }
      it { expect(service.instance_values['active_subscription']).to be_nil }
      it { expect(service.instance_values['stripe_customer']).to eq('stripe_customer_id') }
      it { expect(service.instance_values['payment_source']).to eq(specialist.payment_sources.first) }
    end

    context 'create pro subscription with coupon' do
      let(:params) { { plan: 'specialist_pro', coupon_id: 'K1mvdrdM' } }
      let(:specialist) { create(:specialist_with_primary_payment_source, dashboard_unlocked: false) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_specialist_pro_subscription_with_coupon.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).with(
          'specialist_pro', 'stripe_customer_id',
          coupon: 'K1mvdrdM', cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(specialist.dashboard_unlocked).to be_falsey
        expect(Subscription.count).to be_zero
        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(Subscription.count).to eq(1) }
      it { expect(specialist.dashboard_unlocked).to be_truthy }
      it { expect(specialist.subscriptions.first.local).to be_falsey }
      it { expect(specialist.subscriptions.first.trial_end).to be_nil }
      it { expect(specialist.subscriptions.first.status).to eq('active') }
      it { expect(specialist.subscriptions.first.plan).to eq('specialist_pro') }
      it { expect(specialist.subscriptions.first.amount).to eq(0.2e5) }

      it { expect(service.instance_values['success']).to be_truthy }
      it { expect(service.instance_values['coupon_id']).to eq('K1mvdrdM') }
      it { expect(service.instance_values['plan']).to eq('specialist_pro') }
      it { expect(service.instance_values['specialist']).to eq(specialist) }
      it { expect(service.instance_values['active_subscription']).to be_nil }
      it { expect(service.instance_values['stripe_customer']).to eq('stripe_customer_id') }
      it { expect(service.instance_values['payment_source']).to eq(specialist.payment_sources.first) }
    end

    context 'cancel active free subscription and subscribe to pro plan' do
      let(:params) { { plan: 'specialist_pro' } }
      let(:specialist) { create(:specialist_with_free_subscription) }
      let!(:payment_source) { create(:specialist_payment_source_primary, specialist: specialist) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_specialist_pro_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).with(
          'specialist_pro', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(specialist.dashboard_unlocked).to be_truthy
        expect(Subscription.count).to eq(1)
        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(specialist.subscriptions.size).to eq(2) }
      it { expect(specialist.dashboard_unlocked).to be_truthy }
      it { expect(specialist.subscriptions.first.plan).to eq('free') }
      it { expect(specialist.subscriptions.first.status).to eq('canceled') }
      it { expect(specialist.subscriptions.last.plan).to eq('specialist_pro') }
      it { expect(specialist.subscriptions.last.status).to eq('active') }
      it { expect(service.instance_values['subscription']).to be_present }
    end

    context 'cancel active pro subscription and subscribe to free plan' do
      context 'success cancel' do
        let(:params) { { plan: 'free' } }
        let(:specialist) { create(:specialist_with_pro_subscription) }

        before do
          expect(specialist.dashboard_unlocked).to be_truthy
          expect(specialist.subscriptions.size).to eq(1)
          expect(specialist.subscriptions.last.plan).to eq('specialist_pro')

          stripe_subscription_id = specialist.subscriptions.first.stripe_subscription_id
          expect(Stripe::CancelSubscription).to receive(:call).with(stripe_subscription_id) { true }

          service
        end

        it { expect(service.success?).to be_truthy }
        it { expect(specialist.subscriptions.size).to eq(2) }
        it { expect(specialist.subscriptions.first.plan).to eq('specialist_pro') }
        it { expect(specialist.subscriptions.first.status).to eq('canceled') }
        it { expect(specialist.subscriptions.last.plan).to eq('free') }
        it { expect(specialist.subscriptions.last.status).to eq('active') }

        it { expect(service.instance_values['plan']).to eq('free') }
        it { expect(service.instance_values['coupon_id']).to be_nil }
        it { expect(service.instance_values['success']).to be_truthy }
        it { expect(service.instance_values['payment_source']).to be_nil }
        it { expect(service.instance_values['stripe_customer']).to be_nil }
        it { expect(service.instance_values['specialist']).to eq(specialist) }
        it { expect(service.instance_values['active_subscription']).to eq(specialist.subscriptions.first) }
      end

      context 'cancel with rescue' do
        let(:params) { { plan: 'free' } }
        let(:specialist) { create(:specialist_with_pro_subscription) }

        before do
          expect(specialist.dashboard_unlocked).to be_truthy
          expect(specialist.subscriptions.size).to eq(1)
          expect(specialist.subscriptions.last.plan).to eq('specialist_pro')

          stripe_subscription_id = specialist.subscriptions.first.stripe_subscription_id
          expect(Stripe::CancelSubscription).to receive(:call)
            .with(stripe_subscription_id) { raise Stripe::StripeError, 'No such subscription' }

          service
        end

        it { expect(service.success?).to be_truthy }
        it { expect(specialist.subscriptions.size).to eq(2) }
        it { expect(specialist.subscriptions.last.plan).to eq('free') }
        it { expect(specialist.subscriptions.last.status).to eq('active') }
        it { expect(specialist.subscriptions.first.status).to eq('canceled') }
        it { expect(specialist.subscriptions.first.plan).to eq('specialist_pro') }

        it { expect(service.instance_values['plan']).to eq('free') }
        it { expect(service.instance_values['coupon_id']).to be_nil }
        it { expect(service.instance_values['success']).to be_truthy }
        it { expect(service.instance_values['payment_source']).to be_nil }
        it { expect(service.instance_values['stripe_customer']).to be_nil }
        it { expect(service.instance_values['specialist']).to eq(specialist) }
        it { expect(service.instance_values['active_subscription']).to eq(specialist.subscriptions.first) }
      end
    end
  end
end
