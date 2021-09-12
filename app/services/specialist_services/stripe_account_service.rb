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
        build_stripe_account
      end

      unless stripe_account.save
        @success = false
      end

      self
    end

    private

    def update_stripe_account
      return if section == 'personal' && handle_personal_params
      stripe_account.attributes = account_params
    end

    def handle_personal_params
      attrs = stripe_account.company? ? business_personal_params : individual_personal_params
      @stripe_account = StripeAccount::PersonalInformationForm.for(stripe_account, attrs)
    end

    def business_personal_params
      params.require(:billing).permit(
        :dob, :business_tax_id,
        :city, :state, :zipcode, :address1
      )
    end

    def individual_personal_params
      params.require(:billing).permit(
        :dob, :personal_id_number, :city, :state, :zipcode, :address1
      )
    end

    def build_stripe_account
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
