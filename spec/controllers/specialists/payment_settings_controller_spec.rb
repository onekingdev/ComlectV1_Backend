# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Specialists::PaymentSettingsController, type: :controller do
  let(:specialist) { create :specialist }

  before do
    sign_in specialist.user
  end

  describe 'GET new' do
    it 'has a 200 status code and assigns new account' do
      get :new
      expect(response.status).to eq(200)
    end

    it 'assigns new account' do
      account = StripeAccount::Form.for(::Specialist::Decorator.decorate(specialist))
      get :new
      expect(assigns(:account).specialist).to eq(account.specialist)
    end
  end

  describe 'GET show' do
    it 'has a 200 status code and assign values' do
      account = StripeAccount::Form.for(::Specialist::Decorator.decorate(specialist))
      get :show
      expect(response.status).to eq(200)
      expect(assigns(:payment_source)).to be_a_kind_of NilClass
      expect(assigns(:account).specialist).to eq(account.specialist)
      expect(assigns(:bank_account).stripe_account.specialist).to eq(specialist)
      expect(assigns(:current_bank_account)).to be_a_kind_of NilClass
      expect(assigns(:cards)).to eq(specialist.payment_sources)
    end

    context 'when payment source given' do
      it 'will assign payment source' do
        payment_source = specialist.payment_sources.first
        get :show, params: { payment_source: payment_source.id }
        expect(assigns(:payment_source).id).to eq(payment_source.id)
      end
    end
  end

  describe 'Post Create Bank' do
    it 'Create Bank Account if no payment source' do
      @stripe_test_helper = StripeMock.create_test_helper
      token = @stripe_test_helper.generate_bank_token
      specialist.payment_sources.destroy_all
      params = {
        payment_source: {
          token: token,
          brand: 'Stripe-bank'
        },
        format: :json
      }
      post :create_bank, params: params
      expect(response.status).to eq(201)
    end

    it 'Create Bank Account if already has payment source' do
      @stripe_test_helper = StripeMock.create_test_helper
      token = @stripe_test_helper.generate_bank_token
      specialist.payment_sources.destroy_all
      customer = Stripe::Customer.create(email: specialist&.user&.email,
                                         name: specialist&.user&.full_name)
      bank = Stripe::Customer.create_source(customer.id, source: @stripe_test_helper.generate_bank_token)
      specialist&.payment_sources&.create!(
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
      params = {
        payment_source: {
          token: token,
          brand: 'Stripe-bank'
        },
        format: :json
      }

      post :create_bank, params: params
      expect(response.status).to eq(201)
    end
  end

  describe 'Post Create Card' do
    it 'Create Card Account if no payment source' do
      @stripe_test_helper = StripeMock.create_test_helper
      token = @stripe_test_helper.generate_card_token
      specialist.payment_sources.destroy_all
      params = {
        stripeToken: token,
        format: :json
      }
      post :create_card, params: params
      expect(response.status).to eq(201)
    end

    it 'Create Card Account if already has payment source' do
      @stripe_test_helper = StripeMock.create_test_helper
      token = @stripe_test_helper.generate_card_token
      specialist.payment_sources.destroy_all
      customer = Stripe::Customer.create(email: specialist&.user&.email,
                                         name: specialist&.user&.full_name)
      card = Stripe::Customer.create_source(customer.id, source: @stripe_test_helper.generate_card_token)
      specialist&.payment_sources&.create!(
          stripe_customer_id: customer.id,
          stripe_card_id: card.id,
          brand: card.brand,
          exp_month: card.exp_month,
          exp_year: card.exp_year,
          last4: card.last4
      )
      params = {
        stripeToken: token,
        format: :json
      }

      post :create_card, params: params
      expect(response.status).to eq(201)
    end
  end

  describe 'patch new' do
    it 'make a payment source primary' do
      patch :make_primary, params: { id: specialist.payment_sources.first.id }
      expect(response).to redirect_to(specialists_settings_payment_path)
    end
  end

  describe 'patch new' do
    it 'assigns new account' do
      @stripe_test_helper = StripeMock.create_test_helper
      specialist.payment_sources.destroy_all
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
      data = {
        specialist_payment_source: {
          validate1: 32,
          validate2: 88
        },
        id: payment_source.id
      }
      patch :validate, params: data
      expect(response).to redirect_to(specialists_settings_payment_path)
    end
  end
end
