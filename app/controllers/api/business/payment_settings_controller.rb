# frozen_string_literal: true

class Api::Business::PaymentSettingsController < ApiController
  before_action :require_business!

  def index
    respond_with current_business.payment_sources, each_serializer: ::Business::PaymentSourceSerializer
  end

  def create
    payment_source = payment_source_type.plaid_or_manual current_business, stripe_params

    if payment_source.errors.any?
      respond_with message: { message: payment_source.errors.full_messages.join(', ') }, status: 442
    else
      respond_with payment_source, serializer: ::Business::PaymentSourceSerializer
    end
  end

  def update
    payment_source = current_business.payment_sources.find(params[:id])
    if params.key?(:payment_source_ach)
      payment_source.validate_microdeposits(stripe_validation_params)
      if payment_source.errors.any?
        respond_with(message: { message: @payment_source.errors.full_messages.join(', ') }, status: 442) && return
      else
        payment_source.payment_profile.update(failed: false)
      end
    else
      payment_source.update_from_stripe params[:stripeToken]
    end

    respond_with payment_source, serializer: ::Business::PaymentSourceSerializer
  end

  def make_primary
    payment_source = current_business.payment_sources.find(params[:id])
    payment_source.make_primary!
    respond_with payment_source, serializer: ::Business::PaymentSourceSerializer
  end

  def destroy
    payment_source = current_business.payment_sources.find(params[:id])
    Stripe::DeattachSource.call(current_business.payment_profile.stripe_customer_id, payment_source.stripe_id)
    payment_source.destroy
    respond_with message: { message: 'Payment source was deattached' }, status: :ok
  rescue Stripe::StripeError => e
    respond_with(message: { message: e.message }, status: :unprocessable_entity) && (return)
  end

  private

  def payment_source_type
    params.key?(:stripeToken) ? PaymentSource : PaymentSource::Ach
  end

  def stripe_params(optional: false)
    return params[:stripeToken] if params.key?(:stripeToken)
    return {} if optional && !params.key?(:payment_source_ach)
    root = optional ? params[:payment_source_ach] : params.require(:payment_source_ach)
    root.permit(
      :stripe_id, :country, :currency, :brand, :account_holder_name, :account_holder_type, :last4, :token,
      :plaid_token, :plaid_account_id, :plaid_institution
    ).merge(type: PaymentSource::Ach.name)
  end

  def stripe_validation_params
    params.require(:payment_source_ach).permit(:validate1, :validate2)
  end
end
