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
    @account = StripeAccount::Form.for(current_specialist, account_attributes)
  end

  def create
    @account = StripeAccount::Form.for(current_specialist)
    if @account.update_attributes account_attributes
      redirect_to specialists_settings_payment_path
    else
      render :new
    end
  end

  def edit
    @account = StripeAccount::Form.for(current_specialist)
    render :new
  end

  def update
    @account = StripeAccount::Form.for(current_specialist)
    if @account.update_and_verify(account_attributes)
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
      :account_type, :country, :account_currency, :account_routing_number, :account_number, :address1,
      :zipcode, :city, :state, :country, :first_name, :last_name, :dob, :ssn_last_4, :personal_id_number,
      :personal_address1, :personal_zipcode, :personal_city, :additional_owners,
      :verification_document_data, :verification_document_cache, :business_name, :business_tax_id
    )
  end
end
