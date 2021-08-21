# frozen_string_literal: true

class Api::Specialist::PaymentSettingsController < ApiController
  before_action :require_specialist!

  def index
    respond_with current_specialist.payment_sources, each_serializer: ::Specialist::PaymentSourceSerializer
  end

  def create_card
    service = SpecialistServices::AddCardService.call(current_specialist, payment_params)

    if service.success?
      respond_with service.payment_source, serializer: ::Specialist::PaymentSourceSerializer
    else
      respond_with(error: t('something_went_wrong'), status: :unprocessable_entity)
    end
  rescue Stripe::StripeError => e
    respond_with(error: e.message, status: :unprocessable_entity) and return
  end

  def create_bank
    cus_id = current_specialist.stripe_customer
    unless cus_id
      cus = Stripe::Customer.create(
        email: current_specialist.user.email,
        name: current_specialist.user.full_name
      )
      cus_id = cus.id
    end
    bank = Stripe::Customer.create_source(cus_id, source: params[:payment_source][:token])
    payment_source = current_specialist&.payment_sources&.create!(
        stripe_customer_id: cus_id,
        stripe_card_id: bank.id,
        last4: bank.last4,
        country: bank.country,
        brand: params[:payment_source][:brand],
        bank_account: true,
        currency: bank.currency,
        account_holder_name: bank.account_holder_name,
        account_holder_type: bank.account_holder_type,
        primary: current_specialist&.payment_sources&.length&.zero?
    )
    respond_with payment_source, serializer: ::Specialist::PaymentSourceSerializer
  rescue Stripe::StripeError => e
    respond_with(message: { message: e.message }, status: :unprocessable_entity) && (return)
  end

  def destroy
    payment_source = current_specialist.payment_sources.find(params[:id])
    Stripe::DeattachSource.call(current_specialist.stripe_customer, payment_source.stripe_card_id)
    payment_source.destroy
    respond_with message: { message: t('.payment_source_deattached') }, status: :ok
  rescue Stripe::StripeError => e
    respond_with(message: { message: e.message }, status: :unprocessable_entity) and return
  rescue ActiveRecord::RecordNotFound
    respond_with(message: { message: t('.not_found') }, status: :not_found) and return
  end

  def make_primary
    payment_source = current_specialist.payment_sources.find(params[:id])
    payment_source.make_primary!
    respond_with payment_source, serializer: ::Specialist::PaymentSourceSerializer
  end

  def validate
    payment_source = current_specialist.payment_sources.find(params[:id])
    responce = payment_source.validate_microdeposits(params[:specialist_payment_source])
    respond_with responce, status: :ok
  rescue Stripe::StripeError => e
    respond_with(message: { message: e.message }, status: :unprocessable_entity) && (return)
  end

  private

  def payment_params
    return params if params.key?(:stripeToken)

    params.require(:payment_source_ach).permit(
      :plaid_token,
      :plaid_account_id,
      :plaid_institution
    )
  end
end
