# frozen_string_literal: true

module SpecialistServices
  class BankAccountService < ApplicationService
    attr_reader :specialist, :params, :stripe_account, :bank_account, :error

    def initialize(specialist, params, bank_account = nil)
      @specialist = specialist
      @params = params
      @bank_account = bank_account

      @success = true
    end

    def success?
      @success
    end

    def call
      build_bank_account if bank_account.blank?

      unless bank_account.save
        @success = false
      end

      self
    end

    private

    def build_bank_account
      stripe_account = specialist.stripe_account
      @bank_account = stripe_account.bank_accounts.build(bank_account_params)
    end

    def bank_account_params
      params.require(:bank_account).permit(
        :routing_number, :account_number
      ).tap do |whitelisted|
        country = specialist.stripe_account.country
        currency = Stripe::SUPPORTED_BANK_CURRENCIES[country.to_sym].first

        whitelisted[:country] = country
        whitelisted[:currency] = currency
        whitelisted[:account_number_confirmation] = params[:account_number_confirmation]
      end
    end
  end
end
