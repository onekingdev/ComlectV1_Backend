# frozen_string_literal: true
class Business::PaymentSettingsController < ApplicationController
  before_action :require_business!
  skip_before_action :verify_authenticity_token, only: :create

  def index
    @sources = current_business.payment_sources.sorted
  end

  def show
    @payment_source = PaymentSource::ACHForm.find_for(current_business, params[:id])
  end

  def new
    @payment_source = PaymentSource::ACHForm.new_for(current_business)
  end

  def create
    @payment_source = payment_source_type.add_to current_business, stripe_params
    respond_to do |format|
      format.html { redirect_to business_settings_payment_index_path }
      format.js do
        @payment_source = PaymentSource::ACHForm.new(@payment_source)
        if @payment_source.persisted?
          render :show
        else
          render :new
        end
      end
    end
  end

  def update
    @payment_source = current_business.payment_sources.find(params[:id])
    params.key?(:payment_source_ach) ? handle_ach_update : handle_cc_update
  end

  def make_primary
    @source = current_business.payment_sources.find(params[:payment_id])
    @source.make_primary!
    redirect_to business_settings_payment_index_path
  end

  def destroy
    @source = current_business.payment_sources.find(params[:id])
    @source.destroy
    redirect_to business_settings_payment_index_path
  end

  private

  def handle_ach_update
    @payment_source.validate_microdeposits(stripe_validation_params)
    @payment_source.errors.any? ? render(:show) : js_redirect(business_settings_payment_index_path)
  end

  def handle_cc_update
    @payment_source.update_from_stripe params[:stripeToken]
    redirect_to business_settings_payment_index_path
  end

  def payment_source_type
    params.key?(:stripeToken) ? PaymentSource : PaymentSource::ACH
  end

  def stripe_params
    return params[:stripeToken] if params.key?(:stripeToken)
    params.require(:payment_source_ach).permit(
      :stripe_id, :country, :currency, :brand, :account_holder_name, :account_holder_type, :last4, :token
    ).merge(type: PaymentSource::ACH.name)
  end

  def stripe_validation_params
    params.require(:payment_source_ach).permit(:validate1, :validate2)
  end
end
