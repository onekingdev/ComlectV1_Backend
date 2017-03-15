# frozen_string_literal: true
class Specialists::PaymentSettingsController < ApplicationController
  before_action :require_specialist!

  def index
    @accounts = current_specialist.stripe_accounts.sorted
  end

  def show
    @account = current_specialist.stripe_accounts.find(params[:id])
  end

  def new
    if params[:popup] && current_specialist.stripe_account.nil?
      render 'popup'
    else
      @account = StripeAccount::Form.for(current_specialist, account_attributes_optional)
    end
  end

  def create
    @account = StripeAccount::Form.for(current_specialist, account_attributes)
    if @account.save
      redirect_to specialists_settings_payment_index_path
    else
      render :new
    end
  end

  def edit
    @account = StripeAccount::Form.find(current_specialist, params[:id])
  end

  def update
    @account = StripeAccount::Form.find(current_specialist, params[:id])
    if @account.update_and_verify(account_attributes)
      redirect_to specialists_settings_payment_index_path
    else
      render :edit
    end
  end

  def make_primary
    @account = StripeAccount::Form.find(current_specialist, params[:payment_id])
    @account.make_primary!
    redirect_to specialists_settings_payment_index_path
  end

  def destroy
    account = current_specialist.stripe_accounts.find(params[:id])
    authorize account, :destroy?
    account&.destroy
    redirect_to specialists_settings_payment_path
  end

  private

  def account_attributes
    params.require(:stripe_account).permit(*permitted_attributes)
  end

  def account_attributes_optional
    return {} unless params[:stripe_account]
    params[:stripe_account].permit(*permitted_attributes)
  end

  def permitted_attributes
    %i(
      account_type country account_currency account_routing_number account_number address1
      zipcode city state country first_name last_name dob ssn_last_4 personal_id_number
      personal_address1 personal_zipcode personal_city additional_owners
      verification_document_data verification_document_cache business_name business_tax_id
    )
  end
end
