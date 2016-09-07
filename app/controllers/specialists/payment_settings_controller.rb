# frozen_string_literal: true
class Specialists::PaymentSettingsController < ApplicationController
  before_action :require_specialist!

  def index
    @account = current_specialist.stripe_account
  end

  def show
    @account = current_specialist.stripe_account
  end

  def new
    @account = StripeAccount::Form.for(current_specialist)
  end

  def create
    @account = StripeAccount::Form.for(current_specialist)
    if @account.update_attributes account_attributes
      redirect_to specialists_settings_payment_path
    else
      render :new
    end
  end

  def destroy
    current_specialist.stripe_account&.destroy
    redirect_to specialists_settings_payment_path
  end

  private

  def account_attributes
    params.require(:stripe_account).permit(
      :account_type, :account_country, :account_currency, :account_routing_number, :account_number, :address1,
      :postal_code, :city, :state, :country, :first_name, :last_name, :dob, :ssn_last_4, :personal_id_number,
      :verification_document, :accept_tos, :business_name, :business_tax_id
    ).merge(tos_acceptance_ip: request.remote_ip)
  end
end
