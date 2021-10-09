# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BusinessServices::StripeSubscriptionService do
  let(:service) { described_class.call(business, payment_source, params) }

  describe 'call' do
    context 'plan name wrong' do
      let(:payment_source) { nil }
      let(:business) { create(:business) }

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

    context 'free plan already subscribed' do
      let(:payment_source) { nil }
      let(:params) { { plan: 'free' } }
      let(:msg) { "You have already subscribed to 'Free Plan'" }
      let(:business) { create(:business_with_free_subscription) }

      before do
        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(1)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(0)
        expect(business.subscriptions.active.first.seats.count).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'free').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'free').title).to eq('Free Plan')

        service
      end

      it { expect(service.success?).to be_falsey }
      it { expect(service.error).to eq(msg) }

      it { expect(service.instance_values['plan']).to eq('free') }
      it { expect(service.instance_values['coupon_id']).to be_nil }
      it { expect(service.instance_values['db_seat_count']).to eq(1) }
      it { expect(service.instance_values['business']).to eq(business) }
      it { expect(service.instance_values['payment_source']).to be_nil }
      it { expect(service.instance_values['plan_seat_count']).to eq(1) }
      it { expect(service.instance_values['primary_subscription']).to eq(business.subscriptions.first) }
      it { expect(service.instance_values['active_subscriptions'].first).to eq(business.subscriptions.first) }
    end

    context 'plan team tier annual already subscribed' do
      let(:payment_source) { nil }
      let(:business) { create(:business_with_team_seats) }
      let(:msg) { "You have already subscribed to 'Team Plan'" }
      let!(:params) { { plan: 'team_tier_annual', seats_count: business.seats.size } }

      before do
        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(3)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(2)
        expect(business.subscriptions.active.first.seats.count).to eq(3)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').title).to eq('Team Plan')

        service
      end

      it { expect(service.success?).to be_falsey }
      it { expect(service.error).to eq(msg) }

      it { expect(service.instance_values['plan']).to eq('team_tier_annual') }
      it { expect(service.instance_values['coupon_id']).to be_nil }
      it { expect(service.instance_values['db_seat_count']).to eq(3) }
      it { expect(service.instance_values['business']).to eq(business) }
      it { expect(service.instance_values['payment_source']).to be_nil }
      it { expect(service.instance_values['plan_seat_count']).to eq(3) }
      it { expect(service.instance_values['primary_subscription']).to eq(business.subscriptions.first) }
      it { expect(service.instance_values['active_subscriptions'].first).to eq(business.subscriptions.first) }
    end

    context 'subscribe free plan' do
      let(:payment_source) { nil }
      let(:params) { { plan: 'free' } }
      let(:business) { create(:business) }

      before do
        expect(Seat.count).to be_zero
        expect(Subscription.count).to be_zero
        expect(business.available_seats.size).to eq(0)
        expect(business.onboarding_passed).to be_falsey
        expect(Stripe::CancelSubscription).not_to receive(:call) { true }

        service
      end

      it { expect(service.success?).to be_truthy }

      it { expect(Seat.count).to eq(1) }
      it { expect(TeamMember.count).to eq(1) }
      it { expect(Subscription.count).to eq(1) }

      it { expect(business.seats.last).to be_present }
      it { expect(business.available_seats.size).to eq(0) }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.seats.last.assigned_at).to be_present }
      it { expect(business.subscriptions.first.plan).to eq('free') }
      it { expect(business.subscriptions.first.local).to be_truthy }
      it { expect(business.subscriptions.first.status).to eq('active') }
      it { expect(business.subscriptions.first.title).to eq('Free Plan') }
      it { expect(service.instance_values['subscriptions'].first).to eq(Subscription.last) }
      it { expect(business.team_members.where(email: business.user.email).first).to eq(TeamMember.last) }
    end

    context 'downgrade to free plan' do
      let(:payment_source) { nil }
      let(:params) { { plan: 'free' } }
      let(:business) { create(:business_with_team_seats) }

      before do
        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(3)
        expect(business.team_member).to be_present
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(2)
        expect(business.subscriptions.last.local).to be_falsey
        expect(business.subscriptions.last.status).to eq('active')
        expect(business.subscriptions.last.plan).to eq('team_tier_annual')
        expect(business.seats.where(team_member_id: business.team_member.id)).to be_present
        expect(business.seats.where(team_member_id: business.team_member.id).last.assigned_at).to be_present

        stripe_subscription_id = business.subscriptions.first.stripe_subscription_id
        expect(Stripe::CancelSubscription).to receive(:call)
          .with(stripe_subscription_id) { raise Stripe::StripeError, 'No such subscription' }

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }

      it { expect(Subscription.count).to eq(2) }
      it { expect(business.subscriptions.active.size).to eq(1) }
      it { expect(business.subscriptions.active.last.local).to be_truthy }
      it { expect(business.subscriptions.active.last.plan).to eq('free') }
      it { expect(business.subscriptions.active.last.status).to eq('active') }

      it { expect(business.subscriptions.first.local).to be_falsey }
      it { expect(business.subscriptions.first.status).to eq('canceled') }
      it { expect(business.subscriptions.first.plan).to eq('team_tier_annual') }

      it { expect(business.seats.count).to eq(1) }
      it { expect(business.seats.last.team_member).to eq(business.team_member) }
    end

    context 'downgrade to free plan and lock existing team member' do
      let(:payment_source) { nil }
      let(:params) { { plan: 'free' } }
      let(:business) { create(:business_with_team_seats_and_employee) }

      before do
        expect(business.onboarding_passed).to be_truthy
        expect(business.team_members.size).to eq(2)
        expect(Specialist.count).to eq(1)

        specialist = Specialist.last
        expect(specialist.specialist_invitations.size).to eq(1)
        expect(specialist.dashboard_unlocked).to be_truthy

        invitation = specialist.specialist_invitations.last
        expect(invitation.status).to eq('accepted')

        subscription = business.subscriptions.active.last
        expect(subscription.local).to be_falsey
        expect(subscription.status).to eq('active')
        expect(subscription.plan).to eq('team_tier_annual')
        expect(business.subscriptions.count).to eq(1)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }

      it { expect(Subscription.count).to eq(2) }
      it { expect(business.subscriptions.active.size).to eq(1) }
      it { expect(business.subscriptions.active.last.local).to be_truthy }
      it { expect(business.subscriptions.active.last.plan).to eq('free') }
      it { expect(business.subscriptions.active.last.status).to eq('active') }

      it { expect(business.seats.count).to eq(1) }
      it { expect(business.seats.last.team_member).to eq(business.team_member) }

      it { expect(Specialist::Invitation.last.specialist.dashboard_unlocked).to be_falsey }
    end

    context 'payment source missing' do
      let(:payment_source) { nil }
      let(:params) { { plan: 'team_tier_annual' } }
      let(:business) { create(:business) }

      it { expect(service.success?).to be_falsey }
      it { expect(service.error).to eq('No payment source') }
    end

    context 'create team annual subscription with 1 seat' do
      let(:params) { { plan: 'team_tier_annual', seats_count: 1 } }
      let(:business) { create(:business_with_payment_profile) }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_team_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).with(
          'team_tier_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_falsey
        expect(business.seats.count).to eq(0)
        expect(business.team_member).to be_present
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(0)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(1) }

      it { expect(business.subscriptions.first.local).to be_falsey }
      it { expect(business.subscriptions.first.status).to eq('active') }
      it { expect(business.subscriptions.first.plan).to eq('team_tier_annual') }

      it { expect(business.seats.count).to eq(1) }
      it { expect(business.available_seats.size).to eq(0) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
      it { expect(service.instance_values['plan_seat_count']).to eq(1) }
    end

    context 'create team annual subscription with 2 seats' do
      let(:params) { { plan: 'team_tier_annual', seats_count: 2 } }
      let(:business) { create(:business_with_payment_profile) }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_team_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).with(
          'team_tier_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_falsey
        expect(business.seats.count).to eq(0)
        expect(business.team_member).to be_present
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(0)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(1) }

      it { expect(business.subscriptions.first.local).to be_falsey }
      it { expect(business.subscriptions.first.status).to eq('active') }
      it { expect(business.subscriptions.first.plan).to eq('team_tier_annual') }

      it { expect(business.seats.count).to eq(2) }
      it { expect(business.available_seats.size).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
      it { expect(service.instance_values['plan_seat_count']).to eq(2) }
    end

    context 'create team annual subscription with 3 seats' do
      let(:params) { { plan: 'team_tier_annual', seats_count: 3 } }
      let(:business) { create(:business_with_payment_profile) }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_team_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).with(
          'team_tier_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_falsey
        expect(business.seats.count).to eq(0)
        expect(business.team_member).to be_present
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(0)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(1) }

      it { expect(business.subscriptions.first.local).to be_falsey }
      it { expect(business.subscriptions.first.status).to eq('active') }
      it { expect(business.subscriptions.first.plan).to eq('team_tier_annual') }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
      it { expect(service.instance_values['plan_seat_count']).to eq(3) }
    end

    context 'create team annual subscription with 3 default seats' do
      let(:params) { { plan: 'team_tier_annual' } }
      let(:business) { create(:business_with_payment_profile) }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_team_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).with(
          'team_tier_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_falsey
        expect(business.seats.count).to eq(0)
        expect(business.team_member).to be_present
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(0)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(1) }

      it { expect(business.subscriptions.first.local).to be_falsey }
      it { expect(business.subscriptions.first.status).to eq('active') }
      it { expect(business.subscriptions.first.plan).to eq('team_tier_annual') }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }

      it { expect(service.instance_values['plan_seat_count']).to eq(3) }
      it { expect(service.instance_values['plan']).to eq('team_tier_annual') }
      it { expect(service.instance_values['payment_source']).to eq(payment_source) }
      it { expect(service.instance_values['subscriptions'].first).to eq(Subscription.last) }
      it { expect(service.instance_values['primary_subscription']).to eq(Subscription.last) }
    end

    context 'create team annual subscription with 3 default seats and coupon 50% off' do
      let(:business) { create(:business_with_payment_profile) }
      let(:params) { { plan: 'team_tier_annual', coupon_id: 'coupon_id' } }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_team_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).with(
          'team_tier_annual', 'stripe_customer_id',
          coupon: 'coupon_id', cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_falsey
        expect(business.seats.count).to eq(0)
        expect(business.subscriptions.count).to eq(0)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(1) }

      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('team_tier_annual') }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }

      it { expect(service.instance_values['plan_seat_count']).to eq(3) }
      it { expect(service.instance_values['coupon_id']).to eq('coupon_id') }
      it { expect(service.instance_values['plan']).to eq('team_tier_annual') }
      it { expect(service.instance_values['payment_source']).to eq(payment_source) }
      it { expect(service.instance_values['subscriptions'].first).to eq(Subscription.last) }
      it { expect(service.instance_values['primary_subscription']).to eq(Subscription.last) }
    end

    context 'create team annual and seats annual subscriptions with 4 seats' do
      let(:business) { create(:business_with_payment_profile) }
      let(:params) { { plan: 'team_tier_annual', seats_count: 4 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_team_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      let(:seat_subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_seats_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).once.with(
          'team_tier_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(Subscription).to receive(:subscribe).once.with(
          'seats_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { seat_subscription }

        expect(business.onboarding_passed).to be_falsey
        expect(business.seats.count).to eq(0)
        expect(business.team_member).to be_present
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(0)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }

      it { expect(business.subscriptions.first.quantity).to eq(1) }
      it { expect(business.subscriptions.first.local).to be_falsey }
      it { expect(business.subscriptions.first.kind_of).to eq('ccc') }
      it { expect(business.subscriptions.first.status).to eq('active') }
      it { expect(business.subscriptions.first.amount.to_i).to eq(150_000) }
      it { expect(business.subscriptions.first.plan).to eq('team_tier_annual') }

      it { expect(business.subscriptions.last.quantity).to eq(1) }
      it { expect(business.subscriptions.last.local).to be_falsey }
      it { expect(business.subscriptions.last.kind_of).to eq('seats') }
      it { expect(business.subscriptions.last.status).to eq('active') }
      it { expect(business.subscriptions.last.amount.to_i).to eq(12_000) }
      it { expect(business.subscriptions.last.plan).to eq('seats_annual') }

      it { expect(business.seats.count).to eq(4) }
      it { expect(business.available_seats.size).to eq(3) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }

      it { expect(service.instance_values['plan_seat_count']).to eq(4) }
      it { expect(service.instance_values['plan']).to eq('team_tier_annual') }
      it { expect(service.instance_values['payment_source']).to eq(payment_source) }
      it { expect(service.instance_values['subscriptions'].size).to eq(2) }
      it { expect(service.instance_values['seat_subscription']).to eq(Subscription.last) }
      it { expect(service.instance_values['primary_subscription']).to eq(Subscription.first) }
    end

    context 'cancel team annual and seats annual subscriptions' do
      let(:params) { { plan: 'free' } }
      let(:business) { create(:business_with_team_annual_and_seats_annual_subscriptions) }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      before do
        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(4)
        expect(business.available_seats.size).to eq(2)
        expect(business.team_member).to be_present
        expect(business.team_members.size).to eq(2)
        expect(business.subscriptions.count).to eq(2)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.seats.count).to eq(1) }
      it { expect(business.available_seats.size).to eq(0) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }

      it { expect(business.subscriptions.active.count).to eq(1) }
      it { expect(business.subscriptions.active.first.quantity).to eq(1) }
      it { expect(business.subscriptions.active.first.local).to be_truthy }
      it { expect(business.subscriptions.active.first.plan).to eq('free') }
      it { expect(business.subscriptions.active.first.kind_of).to eq('ccc') }
      it { expect(business.subscriptions.active.first.amount.to_i).to eq(0) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }

      it { expect(business.subscriptions.count).to eq(3) }
      it { expect(business.subscriptions.find_by(plan: 'seats_annual').status).to eq('canceled') }
      it { expect(business.subscriptions.find_by(plan: 'seats_annual').title).to eq('Seats Plan') }
      it { expect(business.subscriptions.find_by(plan: 'team_tier_annual').status).to eq('canceled') }
      it { expect(business.subscriptions.find_by(plan: 'team_tier_annual').title).to eq('Team Plan') }
    end

    context 'upgrade seat count for seats annual subscription from 1 to 2' do
      let(:params) { { plan: 'team_tier_annual', seats_count: 5 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_team_annual_and_seats_annual_subscriptions) }

      let(:seat_subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_seats_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::Subscription).to receive(:retrieve)
          .with('stripe_seats_annual_subscription_id') { seat_subscription }

        expect(Stripe::Subscription).to receive(:update)
          .with(
            'stripe_seats_annual_subscription_id',
            cancel_at_period_end: false,
            proration_behavior: :always_invoice,
            items: [{ quantity: 2, id: 'item_id' }]
          ) { true }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(4)
        expect(business.available_seats.size).to eq(2)
        expect(business.team_member).to be_present
        expect(business.team_members.size).to eq(2)
        expect(business.subscriptions.count).to eq(2)
        expect(business.subscriptions.find_by(plan: 'seats_annual').quantity).to eq(1)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.seats.count).to eq(5) }
      it { expect(business.available_seats.size).to eq(3) }
      it { expect(business.seats.where.not(assigned_at: nil).first.team_member).to eq(business.team_member) }

      it { expect(business.subscriptions.active.count).to eq(2) }
      it { expect(business.subscriptions.active.first.quantity).to eq(1) }
      it { expect(business.subscriptions.active.first.seats.count).to eq(3) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.kind_of).to eq('ccc') }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.amount.to_i).to eq(150_000) }
      it { expect(business.subscriptions.active.first.plan).to eq('team_tier_annual') }

      it { expect(business.subscriptions.active.last.quantity).to eq(2) }
      it { expect(business.subscriptions.active.last.seats.count).to eq(2) }
      it { expect(business.subscriptions.active.last.local).to be_falsey }
      it { expect(business.subscriptions.active.last.kind_of).to eq('seats') }
      it { expect(business.subscriptions.active.last.status).to eq('active') }
      it { expect(business.subscriptions.active.last.amount.to_i).to eq(12_000) }
      it { expect(business.subscriptions.active.last.plan).to eq('seats_annual') }
    end

    context 'cancel only seats annual subscription' do
      let(:params) { { plan: 'team_tier_annual', seats_count: 3 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_team_annual_and_seats_annual_subscriptions) }

      before do
        expect(business.seats.count).to eq(4)
        expect(business.team_members.size).to eq(2)
        expect(business.subscriptions.count).to eq(2)
        expect(business.available_seats.size).to eq(2)
        expect(business.onboarding_passed).to be_truthy
        expect(business.subscriptions.find_by(plan: 'seats_annual').quantity).to eq(1)

        service
      end

      it { expect(service.success?).to be_truthy }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.available_seats.size).to eq(1) }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.active.count).to eq(1) }
      it { expect(business.subscriptions.active.first.seats.count).to eq(3) }
      it { expect(business.subscriptions.find_by(plan: 'seats_annual').status).to eq('canceled') }
      it { expect(business.subscriptions.find_by(plan: 'team_tier_annual').status).to eq('active') }
    end

    context 'downgrade seats annual from 5 to 4' do
      let(:params) { { plan: 'team_tier_annual', seats_count: 4 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_team_annual_and_seats_annual_subscriptions_5_seats) }

      let(:seat_subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_seats_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::Subscription).to receive(:retrieve)
          .with('stripe_seats_annual_subscription_id') { seat_subscription }

        expect(Stripe::Subscription).to receive(:update)
          .with(
            'stripe_seats_annual_subscription_id',
            proration_behavior: :none,
            items: [{ quantity: 1, id: 'item_id' }]
          ) { true }

        expect(business.seats.count).to eq(5)
        expect(business.team_members.size).to eq(2)
        expect(business.subscriptions.count).to eq(2)
        expect(business.available_seats.size).to eq(3)
        expect(business.onboarding_passed).to be_truthy
        expect(business.subscriptions.find_by(plan: 'seats_annual').quantity).to eq(2)
        expect(business.subscriptions.find_by(plan: 'seats_annual').seats.count).to eq(2)

        service
      end

      it { expect(service.success?).to be_truthy }

      it { expect(business.seats.count).to eq(4) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.active.count).to eq(2) }
      it { expect(business.subscriptions.active.find_by(plan: 'seats_annual').quantity).to eq(1) }
      it { expect(business.subscriptions.active.find_by(plan: 'seats_annual').seats.count).to eq(1) }
      it { expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').quantity).to eq(1) }
      it { expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').seats.count).to eq(3) }
    end

    context 'upgrade seat count for team annual subscription from 1 to 5' do
      let(:params) { { plan: 'team_tier_annual', seats_count: 5 } }
      let(:business) { create(:team_annual_business_with_one_seat) }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      let(:seat_subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_seats_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).once.with(
          'seats_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 2
        ) { seat_subscription }

        expect(business.seats.count).to eq(1)
        expect(business.team_member).to be_present
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(0)
        expect(business.onboarding_passed).to be_truthy
        expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').quantity).to eq(1)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.seats.count).to eq(5) }
      it { expect(business.team_member).to be_present }
      it { expect(business.team_members.size).to eq(1) }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.available_seats.size).to eq(4) }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.active.find_by(plan: 'seats_annual').quantity).to eq(2) }
      it { expect(business.subscriptions.active.find_by(plan: 'seats_annual').seats.count).to eq(2) }
      it { expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').quantity).to eq(1) }
      it { expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').seats.count).to eq(3) }
    end

    context 'create business annual subscription with 10 default seats' do
      let(:params) { { plan: 'business_tier_annual' } }
      let(:business) { create(:business_with_payment_profile) }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_business_annual_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Subscription).to receive(:subscribe).with(
          'business_tier_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_falsey
        expect(business.seats.count).to eq(0)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(0)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(1) }

      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('business_tier_annual') }

      it { expect(business.seats.count).to eq(10) }
      it { expect(business.available_seats.size).to eq(9) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }

      it { expect(service.instance_values['plan_seat_count']).to eq(10) }
      it { expect(service.instance_values['plan']).to eq('business_tier_annual') }
      it { expect(service.instance_values['payment_source']).to eq(payment_source) }
      it { expect(service.instance_values['subscriptions'].first).to eq(Subscription.last) }
      it { expect(service.instance_values['primary_subscription']).to eq(Subscription.last) }
    end

    context 'upgrade_free_plan_to_team_tier_monthly' do
      let(:params) { { plan: 'team_tier_monthly', seats_count: 3 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_free_subscription_and_payment_profile) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::CancelSubscription).not_to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'team_tier_monthly', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.seats.count).to eq(1)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(0)
        expect(business.onboarding_passed).to be_truthy
        expect(business.subscriptions.active.find_by(plan: 'free').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.reload.subscriptions.active.count).to eq(1) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(3) }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.subscriptions.active.first.title).to eq('Team Plan') }
      it { expect(business.subscriptions.active.first.plan).to eq('team_tier_monthly') }
      it { expect(business.subscriptions.find_by(plan: 'free').status).to eq('canceled') }
      it { expect(service.instance_values['free_subscription']).to eq(Subscription.first) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'upgrade_team_tier_monthly_to_team_tier_annual' do
      let(:params) { { plan: 'team_tier_annual' } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_team_monthly_subscription_and_seats, :with_default_seats) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::Subscription).to receive(:retrieve)
          .with('stripe_sub_id') { subscription }

        expect(Stripe::Subscription).to receive(:update)
          .with(
            'stripe_subscription_id',
            proration_behavior: :none,
            cancel_at_period_end: false,
            items: [{ price: 'team_tier_annual', id: 'item_id' }]
          ) { true }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(3)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(2)
        expect(business.subscriptions.active.first.seats.count).to eq(3)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_monthly').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_monthly').title).to eq('Team Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(1) }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(3) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('team_tier_annual') }
      it { expect(business.subscriptions.active.first.title).to eq('Team Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'upgrade_team_tier_monthly_to_business_tier_monthly' do
      let(:params) { { plan: 'business_tier_monthly' } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_team_monthly_subscription_and_seats, :with_default_seats) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::CancelSubscription).to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'business_tier_monthly', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(3)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(2)
        expect(business.subscriptions.active.first.seats.count).to eq(3)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_monthly').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_monthly').title).to eq('Team Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.subscriptions.active.count).to eq(1) }

      it { expect(business.seats.count).to eq(10) }
      it { expect(business.available_seats.size).to eq(9) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(10) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('business_tier_monthly') }
      it { expect(business.subscriptions.active.first.title).to eq('Business Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'upgrade_team_tier_monthly_to_business_tier_annual' do
      let(:params) { { plan: 'business_tier_annual' } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_team_monthly_subscription_and_seats, :with_default_seats) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::CancelSubscription).to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'business_tier_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(3)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(2)
        expect(business.subscriptions.active.first.seats.count).to eq(3)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_monthly').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_monthly').title).to eq('Team Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.subscriptions.active.count).to eq(1) }

      it { expect(business.seats.count).to eq(10) }
      it { expect(business.available_seats.size).to eq(9) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(10) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('business_tier_annual') }
      it { expect(business.subscriptions.active.first.title).to eq('Business Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'upgrade_team_tier_annual_to_business_tier_monthly' do
      let(:params) { { plan: 'business_tier_monthly', seats_count: 10 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_team_seats) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::CancelSubscription).to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'business_tier_monthly', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(3)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(2)
        expect(business.subscriptions.active.first.seats.count).to eq(3)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').title).to eq('Team Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.subscriptions.active.count).to eq(1) }

      it { expect(business.seats.count).to eq(10) }
      it { expect(business.available_seats.size).to eq(9) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(10) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('business_tier_monthly') }
      it { expect(business.subscriptions.active.first.title).to eq('Business Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'upgrade_team_tier_annual_to_business_tier_annual' do
      let(:params) { { plan: 'business_tier_annual' } }
      let(:business) { create(:business_with_team_seats) }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::CancelSubscription).to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'business_tier_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(3)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(2)
        expect(business.subscriptions.active.first.seats.count).to eq(3)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').title).to eq('Team Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.subscriptions.active.count).to eq(1) }

      it { expect(business.seats.count).to eq(10) }
      it { expect(business.available_seats.size).to eq(9) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(10) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('business_tier_annual') }
      it { expect(business.subscriptions.active.first.title).to eq('Business Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'upgrade_business_tier_monthly_to_business_tier_annual' do
      let(:params) { { plan: 'business_tier_annual', seats_count: 10 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_business_tier_monthly_subscription_and_seats, :with_default_seats) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::Subscription).to receive(:retrieve)
          .with('stripe_sub_id') { subscription }

        expect(Stripe::Subscription).to receive(:update)
          .with(
            'stripe_subscription_id',
            proration_behavior: :none,
            cancel_at_period_end: false,
            items: [{ price: 'business_tier_annual', id: 'item_id' }]
          ) { true }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(10)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(9)
        expect(business.subscriptions.active.first.seats.count).to eq(10)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_monthly').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_monthly').title).to eq('Business Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(1) }

      it { expect(business.seats.count).to eq(10) }
      it { expect(business.available_seats.size).to eq(9) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(10) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('business_tier_annual') }
      it { expect(business.subscriptions.active.first.title).to eq('Business Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'downgrade_business_tier_annual_to_business_tier_monthly' do
      let(:params) { { plan: 'business_tier_monthly', seats_count: 10 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_business_tier_annual_subscription_and_seats, :with_default_seats) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      let(:data) { double('data', data: []) }
      let(:upcoming_invoice) { double('UpcomingInvoice', lines: data) }

      before do
        Timecop.freeze(Time.now.utc)

        expect(Stripe::Subscription).to receive(:retrieve)
          .with('stripe_sub_id') { subscription }

        expect(Stripe::Invoice).to receive(:upcoming)
          .with(
            customer: 'stripe_customer_id',
            subscription_items: [{ id: 'item_id', plan: 'plan_id', quantity: 0 }],
            subscription: subscription,
            subscription_proration_date: Time.now.utc.to_i
          ) { upcoming_invoice }

        expect(Stripe::CancelSubscription).to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'business_tier_monthly', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(10)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(9)
        expect(business.subscriptions.active.first.seats.count).to eq(10)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_annual').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_annual').title).to eq('Business Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }

      it { expect(business.seats.count).to eq(10) }
      it { expect(business.available_seats.size).to eq(9) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(10) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('business_tier_monthly') }
      it { expect(business.subscriptions.active.first.title).to eq('Business Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'downgrade_business_tier_annual_to_team_tier_annual' do
      let(:params) { { plan: 'team_tier_annual', seats_count: 3 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_business_tier_annual_subscription_and_seats, :with_default_seats) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      let(:data) { double('data', data: []) }
      let(:upcoming_invoice) { double('UpcomingInvoice', lines: data) }

      before do
        Timecop.freeze(Time.now.utc)

        expect(Stripe::Subscription).to receive(:retrieve)
          .with('stripe_sub_id') { subscription }

        expect(Stripe::Invoice).to receive(:upcoming)
          .with(
            customer: 'stripe_customer_id',
            subscription_items: [{ id: 'item_id', plan: 'plan_id', quantity: 0 }],
            subscription: subscription,
            subscription_proration_date: Time.now.utc.to_i
          ) { upcoming_invoice }

        expect(Stripe::CancelSubscription).to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'team_tier_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(10)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(9)
        expect(business.subscriptions.active.first.seats.count).to eq(10)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_annual').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_annual').title).to eq('Business Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.subscriptions.active.count).to eq(1) }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(3) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('team_tier_annual') }
      it { expect(business.subscriptions.active.first.title).to eq('Team Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'downgrade_business_tier_annual_to_team_tier_monthly' do
      let(:params) { { plan: 'team_tier_monthly', seats_count: 3 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_business_tier_annual_subscription_and_seats, :with_default_seats) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      let(:data) { double('data', data: []) }
      let(:upcoming_invoice) { double('UpcomingInvoice', lines: data) }

      before do
        Timecop.freeze(Time.now.utc)

        expect(Stripe::Subscription).to receive(:retrieve)
          .with('stripe_sub_id') { subscription }

        expect(Stripe::Invoice).to receive(:upcoming)
          .with(
            customer: 'stripe_customer_id',
            subscription_items: [{ id: 'item_id', plan: 'plan_id', quantity: 0 }],
            subscription: subscription,
            subscription_proration_date: Time.now.utc.to_i
          ) { upcoming_invoice }

        expect(Stripe::CancelSubscription).to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'team_tier_monthly', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(10)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(9)
        expect(business.subscriptions.active.first.seats.count).to eq(10)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_annual').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_annual').title).to eq('Business Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.subscriptions.active.count).to eq(1) }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(3) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('team_tier_monthly') }
      it { expect(business.subscriptions.active.first.title).to eq('Team Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'downgrade_business_tier_monthly_to_team_tier_annual' do
      let(:params) { { plan: 'team_tier_annual', seats_count: 3 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_business_tier_monthly_subscription_and_seats, :with_default_seats) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::CancelSubscription).to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'team_tier_annual', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(10)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(9)
        expect(business.subscriptions.active.first.seats.count).to eq(10)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_monthly').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_monthly').title).to eq('Business Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.subscriptions.active.count).to eq(1) }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(3) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('team_tier_annual') }
      it { expect(business.subscriptions.active.first.title).to eq('Team Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'downgrade_business_tier_monthly_to_team_tier_monthly' do
      let(:params) { { plan: 'team_tier_monthly' } }
      let(:payment_source) { business.payment_profile&.default_payment_source }
      let(:business) { create(:business_with_business_tier_monthly_subscription_and_seats, :with_default_seats) }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      before do
        expect(Stripe::CancelSubscription).to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'team_tier_monthly', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(10)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(9)
        expect(business.subscriptions.active.first.seats.count).to eq(10)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_monthly').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'business_tier_monthly').title).to eq('Business Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.subscriptions.active.count).to eq(1) }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(3) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('team_tier_monthly') }
      it { expect(business.subscriptions.active.first.title).to eq('Team Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end

    context 'downgrade_team_tier_annual_to_team_tier_monthly' do
      let(:business) { create(:business_with_team_seats) }
      let(:params) { { plan: 'team_tier_monthly', seats_count: 3 } }
      let(:payment_source) { business.payment_profile&.default_payment_source }

      let(:subscription) do
        JSON.parse(
          File.read('spec/webmock/stripe_subscription.json'),
          object_class: OpenStruct
        )
      end

      let(:data) { double('data', data: []) }
      let(:upcoming_invoice) { double('UpcomingInvoice', lines: data) }

      before do
        Timecop.freeze(Time.now.utc)

        expect(Stripe::Subscription).to receive(:retrieve)
          .with('stripe_sub_id') { subscription }

        expect(Stripe::Invoice).to receive(:upcoming)
          .with(
            customer: 'stripe_customer_id',
            subscription_items: [{ id: 'item_id', plan: 'plan_id', quantity: 0 }],
            subscription: subscription,
            subscription_proration_date: Time.now.utc.to_i
          ) { upcoming_invoice }

        expect(Stripe::CancelSubscription).to receive(:call) { true }

        expect(Subscription).to receive(:subscribe).with(
          'team_tier_monthly', 'stripe_customer_id',
          coupon: nil, cancel_at_period_end: false, quantity: 1
        ) { subscription }

        expect(business.onboarding_passed).to be_truthy
        expect(business.seats.count).to eq(3)
        expect(business.team_members.size).to eq(1)
        expect(business.subscriptions.count).to eq(1)
        expect(business.available_seats.size).to eq(2)
        expect(business.subscriptions.active.first.seats.count).to eq(3)
        expect(business.seats.where.not(assigned_at: nil).count).to eq(1)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').quantity).to eq(1)
        expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member)
        expect(business.subscriptions.active.find_by(plan: 'team_tier_annual').title).to eq('Team Plan')

        service
      end

      it { expect(service.success?).to be_truthy }
      it { expect(business.onboarding_passed).to be_truthy }
      it { expect(business.subscriptions.count).to eq(2) }
      it { expect(business.subscriptions.active.count).to eq(1) }

      it { expect(business.seats.count).to eq(3) }
      it { expect(business.available_seats.size).to eq(2) }
      it { expect(business.subscriptions.active.first.local).to be_falsey }
      it { expect(business.subscriptions.active.first.seats.count).to eq(3) }
      it { expect(business.subscriptions.active.first.status).to eq('active') }
      it { expect(business.subscriptions.active.first.plan).to eq('team_tier_monthly') }
      it { expect(business.subscriptions.active.first.title).to eq('Team Plan') }
      it { expect(business.seats.where.not(assigned_at: nil).count).to eq(1) }
      it { expect(business.seats.where.not(assigned_at: nil).last.team_member).to eq(business.team_member) }
    end
  end
end
