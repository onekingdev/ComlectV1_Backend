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

  def update
    @payment_target = current_business.payment_targets.find(params[:id])
    params.key?(:payment_target_ach) ? handle_ach_update : handle_cc_update
  end

  def make_primary
    @target = current_business.payment_targets.find(params[:payment_id])
    @target.make_primary!
    redirect_to business_settings_payment_index_path
  end

  def destroy
    @target = current_business.payment_targets.find(params[:id])
    @target.destroy
    redirect_to business_settings_payment_index_path
  end

  private

  def account_attributes
    params.require(:stripe_account).permit(
      :account_country, :account_currency, :account_routing_number, :account_number, :address1, :postal_code,
      :city, :state, :country, :first_name, :last_name, :dob, :ssn_last_4, :personal_id_number,
      :verification_document, :accept_tos
    )
  end
end
