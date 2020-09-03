# frozen_string_literal: true

class Business::PaymentSettingsController < ApplicationController
  before_action :require_business!
  skip_before_action :verify_authenticity_token, only: %i[create apply_coupon]

  def index
    if !current_business.onboarding_passed
      redirect_to '/business/onboarding'
    else
      @sources = current_business.payment_sources.sorted
    end
  end

  def show
    @payment_source = PaymentSource::ACHForm.find_for(current_business, params[:id])
  end

  def new
    @payment_source = PaymentSource::ACHForm.new_for(current_business, stripe_params(optional: true))
  end

  def create
    @payment_source = payment_source_type.plaid_or_manual current_business, stripe_params
    @payment_source.update(coupon_id: params[:coupon_id].to_s)
    respond_to do |format|
      format.html do
        alert = @payment_source.errors[:base].any? ? @payment_source.errors[:base].to_sentence : nil
        redirect_to business_settings_payment_index_path, alert: alert
      end
      format.js do
        @payment_source = PaymentSource::ACHForm.new(@payment_source)
        render @payment_source.persisted? ? :show : :new
      end
      format.json do
        if @payment_source.errors[:base].any?
          content = {
            error: true,
            message: @payment_source.errors.full_messages.join(', ')
          }
          status = 442
        else
          content = @payment_source.to_json
          status = :created
        end
        render json: content, status: status
      end
    end
  end

  def apply_coupon
    coupon = JSON.parse(request.body.read, symbolize_names: true)[:coupon]
    if coupon.present?
      valid_id = found_in_coupons(coupon)
      valid_id ||= found_in_promotions(coupon)
      if valid_id
        render json: { message: 'Coupon code applied successfully.', coupon_id: valid_id, is_valid: true }, status: :ok
      else
        render json: { message: 'Entered Coupon code is not valid.', is_valid: false }, status: :unprocessable_entity
      end
    else
      render json: { message: 'Please enter the code first.', is_valid: false }, status: :bad_request
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
    authorize @source, :destroy?
    @source.destroy
    redirect_to business_settings_payment_index_path
  end

  private

  def found_in_coupons(code)
    Stripe::Coupon.retrieve(code).id
  rescue
    false
  end

  def found_in_promotions(code)
    Stripe::PromotionCode.list(limit: 100).auto_paging_each do |promo|
      return promo.coupon.id if promo.code == code
    end
    false
  end

  def handle_ach_update
    @payment_source.validate_microdeposits(stripe_validation_params)
    if @payment_source.errors.any?
      render(:show)
    else
      @payment_source.payment_profile.update(failed: false)
      js_redirect(business_settings_payment_index_path)
    end
  end

  def handle_cc_update
    @payment_source.update_from_stripe params[:stripeToken]
    redirect_to business_settings_payment_index_path
  end

  def payment_source_type
    params.key?(:stripeToken) ? PaymentSource : PaymentSource::ACH
  end

  def stripe_params(optional: false)
    return params[:stripeToken] if params.key?(:stripeToken)
    return {} if optional && !params.key?(:payment_source_ach)
    root = optional ? params[:payment_source_ach] : params.require(:payment_source_ach)
    root.permit(
      :stripe_id, :country, :currency, :brand, :account_holder_name, :account_holder_type, :last4, :token,
      :plaid_token, :plaid_account_id, :plaid_institution
    ).merge(type: PaymentSource::ACH.name)
  end

  def stripe_validation_params
    params.require(:payment_source_ach).permit(:validate1, :validate2)
  end
end
