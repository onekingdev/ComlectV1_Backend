# frozen_string_literal: true

module SpecialistServices
  class AddCardService < ApplicationService
    attr_reader :specialist, :params, :payment_source, :customer_id

    def initialize(specialist, params)
      @specialist = specialist
      @params = params
      @success = true
    end

    def success?
      @success
    end

    def call
      params[:stripeToken] ? add_card : add_bank_account

      self
    end

    private

    def add_card
      card = Stripe::Customer.create_source(
        get_customer_id, source: params[:stripeToken]
      )

      @payment_source = specialist.payment_sources.create(
        brand: card.brand,
        last4: card.last4,
        exp_year: card.exp_year,
        stripe_card_id: card.id,
        exp_month: card.exp_month,
        stripe_customer_id: customer_id,
        primary: specialist.payment_sources.size.zero?
      )
    end

    def add_bank_account
      data = load_bank_account
      @payment_source = create_payment_source(data)
    end

    def load_bank_account
      client = Plaid::Client.new(
        env: ENV['PLAID_ENV'],
        secret: ENV['PLAID_SECRET'],
        client_id: ENV['PLAID_CLIENT_ID'],
        public_key: ENV['PLAID_PUBLIC_KEY']
      )

      exchange_token_response = client.item.public_token.exchange(params[:plaid_token])
      access_token = exchange_token_response.access_token

      stripe_response = client.processor.stripe.bank_account_token.create(
        access_token, params[:plaid_account_id]
      )

      bank_account_token = stripe_response.stripe_bank_account_token

      {
        validated: true,
        token: bank_account_token,
        brand: params[:plaid_institution]
      }
    end

    def create_payment_source(data)
      bank = Stripe::Customer.create_source(
        get_customer_id, source: data[:token]
      )

      specialist.payment_sources.create(
        last4: bank.last4,
        bank_account: true,
        brand: data[:brand],
        country: bank.country,
        stripe_card_id: bank.id,
        currency: bank.currency,
        validated: data[:validated],
        stripe_customer_id: customer_id,
        account_holder_name: bank.account_holder_name,
        account_holder_type: bank.account_holder_type,
        primary: specialist.payment_sources.size.zero?
      )
    end

    def get_customer_id
      stripe_customer_id = specialist.stripe_customer
      return stripe_customer_id if stripe_customer_id.present?

      customer = Stripe::Customer.create(
        email: specialist.user.email,
        name: specialist.user.full_name
      )

      @customer_id = customer.id
    end
  end
end
