# frozen_string_literal: true

module SpecialistServices
  class StripeAccountService < ApplicationService
    attr_reader :specialist, :params, :stripe_account, :account_type, :error, :section

    def initialize(specialist, params, stripe_account = nil)
      @specialist = specialist
      @params = params
      @stripe_account = stripe_account

      @success = true
      @section = params[:section]
      @account_type = params[:account_type] || stripe_account&.account_type
    end

    def success?
      @success
    end

    def call
      if stripe_account.present?
        update_stripe_account
      else
        create_stripe_account
      end

      unless stripe_account.save
        @success = false
      end

      self
    end

    private

    def update_stripe_account
      attrs = section == 'personal' ? personal_params : account_params
      stripe_account.attributes = attrs
    end

    def personal_params
      if stripe_account.company?
        business_account_information_params
      else
        address_params.tap do |whitelisted|
          whitelisted['active'] = false
          whitelisted['disabled_at'] = Time.zone.now
        end
      end
    end

    def address_params
      params.require(:billing).permit(
        :city, :state, :zipcode, :apartment, :address_1
      )
    end

    def create_stripe_account
      @stripe_account = specialist.build_stripe_account(account_params)
    end

    def account_params
      if account_type == 'company'
        business_account_information_params
      elsif account_type == 'individual'
        individual_account_information_params
      else
        params.permit(:account_type, :country)
      end
    end

    def individual_account_information_params
      params.require(:billing).permit(
        :account_type, :first_name, :last_name, :country
      )
    end

    def business_account_information_params
      params.require(:billing).permit(:account_type, :business_name, :country)
    end
  end
end
