# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:klass) { described_class }

  # columns
  # ======

  describe 'columns' do
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:business_id).of_type(:integer) }
    it { should have_db_column(:stripe_subscription_id).of_type(:string) }
    it { should have_db_column(:stripe_invoice_item_id).of_type(:string) }
    it { should have_db_column(:plan).of_type(:integer).with_options(default: :seats_monthly) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:kind_of).of_type(:integer).with_options(default: :ccc) }
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:billing_period_ends).of_type(:integer) }
    it { should have_db_column(:payment_source_id).of_type(:integer) }
    it { should have_db_column(:auto_renew).of_type(:boolean).with_options(default: false) }
    it { should have_db_column(:status).of_type(:integer).with_options(default: :active) }
    it { should have_db_column(:specialist_id).of_type(:integer) }
    it { should have_db_column(:specialist_payment_source_id).of_type(:integer) }
    it { should have_db_column(:quantity).of_type(:integer) }
  end

  # constants
  # =========

  describe 'SPECIALIST_PLANS' do
    let(:plans) do
      {
        1 => 'free',
        2 => 'team_tier_monthly',
        3 => 'team_tier_annual',
        4 => 'business_tier_monthly',
        5 => 'business_tier_annual'
      }
    end

    it { expect(klass::SPECIALIST_PLANS).to eq(%w[specialist_pro free]) }
    it { expect(klass::BUSINESS_PLANS).to eq(plans) }
  end

  # associations
  # ============

  describe 'associations' do
    it { should belong_to(:business).optional }
    it { should belong_to(:specialist).optional }
    it { should belong_to(:payment_source).optional }

    it do
      should belong_to(:specialist_payment_source)
        .class_name('Specialist::PaymentSource')
        .with_foreign_key(:specialist_payment_source_id)
        .optional
    end
  end

  # enums
  # =====

  describe 'enums' do
    let(:plans) do
      %w[
        seats_monthly
        seats_annual
        team_tier_monthly
        team_tier_annual
        business_tier_monthly
        business_tier_annual
        specialist_pro
        free
      ]
    end

    it { should define_enum_for(:plan).with_values(plans) }
    it { should define_enum_for(:status).with_values(active: 0, canceled: 1) }
    it { should define_enum_for(:kind_of).with_values(ccc: 0, forum: 1, seats: 2) }
  end

  # class methods
  # =============

  describe '.get_plan_id' do
    it { expect(klass.get_plan_id('SEATS_monthly')).to eq('seats_monthly') }
    it { expect(klass.get_plan_id('seats_ANNUAL')).to eq('seats_annual') }

    it { expect(klass.get_plan_id('team_tier_monthly')).to eq('team_tier_monthly') }
    it { expect(klass.get_plan_id('team_tier_annual')).to eq('team_tier_annual') }

    it { expect(klass.get_plan_id('business_tier_monthly')).to eq('business_tier_monthly') }
    it { expect(klass.get_plan_id('business_tier_annual')).to eq('business_tier_annual') }

    it { expect(klass.get_plan_id('specialist_pro')).to eq('specialist_pro') }
  end

  describe '.subscribe' do
    it 'invalid plan' do
      expect(Stripe::Subscription).not_to receive(:create)
      expect(klass.subscribe('invalid plan', '')).to be_nil
    end

    context 'success response' do
      let(:response) { double('StripeSubscription') }

      let(:default_params) do
        {
          customer: 'customer_id',
          items: [{ plan: 'specialist_pro', quantity: 1 }]
        }
      end

      let(:custom_options) do
        {
          quantity: 2,
          coupon: 'coupon',
          period_ends: 'period_ends'
        }
      end

      let(:custom_params) do
        {
          cancel_at: 'period_ends',
          coupon: 'coupon',
          customer: 'customer_id',
          items: [{ plan: 'specialist_pro', quantity: 2 }],
          proration_behavior: :none
        }
      end

      it 'without options' do
        expect(Stripe::Subscription).to receive(:create).with(default_params) { response }
        expect(klass.subscribe('specialist_pro', 'customer_id')).to eq(response)
      end

      it 'with custom options' do
        expect(Stripe::Subscription).to receive(:create).with(custom_params) { response }
        expect(klass.subscribe('specialist_pro', 'customer_id', custom_options)).to eq(response)
      end
    end
  end

  describe '.create_invoice_item' do
    let(:response) { double('SuccessStripeInvoiceItem') }

    let(:expected_attrs) do
      {
        amount: 50_000,
        currency: 'usd',
        customer: 'customer_id',
        description: 'On-boarding fee'
      }
    end

    it 'success response' do
      expect(Stripe::InvoiceItem).to receive(:create).with(expected_attrs) { response }
      expect(klass.create_invoice_item('customer_id')).to eq(response)
    end
  end
end
