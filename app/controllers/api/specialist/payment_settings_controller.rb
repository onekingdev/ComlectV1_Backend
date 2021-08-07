# frozen_string_literal: true

class Api::Specialist::PaymentSettingsController < ApiController
  before_action :require_specialist!

  def index
    respond_with current_specialist.payment_sources, each_serializer: ::Specialist::PaymentSourceSerializer
  end

  def create_card
    cus_id = current_specialist&.stripe_customer
    unless cus_id
      cus = Stripe::Customer.create(
        email: current_specialist&.user&.email,
        name: current_specialist&.user&.full_name
      )
      cus_id = cus.id
    end
    card = Stripe::Customer.create_source(cus_id, source: params[:stripeToken])

    payment_source = current_specialist&.payment_sources&.create!(
      stripe_customer_id: cus_id,
      stripe_card_id: card.id,
      brand: card.brand,
      exp_month: card.exp_month,
      exp_year: card.exp_year,
      last4: card.last4,
      primary: current_specialist&.payment_sources&.length&.zero?
    )
    respond_with payment_source, serializer: ::Specialist::PaymentSourceSerializer
  rescue Stripe::StripeError => e
    respond_with(message: { message: e.message }, status: :unprocessable_entity) && (return)
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

  def delete_source
    payment_source = current_specialist.payment_sources.find(params[:id])
    Stripe::DeattachSource.call(current_specialist.stripe_customer, payment_source.stripe_card_id)
    payment_source.destroy
    respond_with message: { message: I18n.t('api.specialist.payment_settings.payment_source_deattached') }, status: :ok
  rescue Stripe::StripeError => e
    respond_with(message: { message: e.message }, status: :unprocessable_entity) && (return)
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
end
