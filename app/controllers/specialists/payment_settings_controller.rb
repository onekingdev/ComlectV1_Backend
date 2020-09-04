# frozen_string_literal: true

class Specialists::PaymentSettingsController < ApplicationController
  before_action :require_specialist!

  def show
    redirect_to specialists_settings_path if current_specialist.team

    @account = StripeAccount::Form.for(current_specialist)
    @bank_accounts = @account.bank_accounts
    @cards = current_specialist&.payment_sources
  end

  def new
    @account = StripeAccount::Form.for(current_specialist, account_attributes_optional)
  end

  def create
    @account = StripeAccount::Form.for(current_specialist, account_attributes)
    authorize @account, :create?

    if @account.save && @account.errors.empty?
      redirect_to specialists_settings_payment_path
    else
      render :new
    end
  end

  def edit
    @account = StripeAccount::Form.for(current_specialist, account_attributes_optional)
  end

  def update
    @account = StripeAccount::Form.for(current_specialist)
    authorize @account, :update?

    if @account.update_and_verify(account_attributes)
      redirect_to specialists_settings_payment_path
    else
      render :edit
    end
  end

  def destroy
    account = current_specialist.stripe_account
    authorize account, :destroy?
    account.destroy
    redirect_to specialists_settings_payment_path
  end

  def new_card
    stripe_account = @stripe_account ||= current_specialist.stripe_account
    @bank_account = BankAccount::Create.new(stripe_account: stripe_account)
    respond_to do |format|
      format.js
    end
  end

  def create_card
    begin
      cus_id = current_specialist&.stripe_customer
      unless cus_id
        cus = Stripe::Customer.create(
          email: current_specialist&.user&.email,
          name: current_specialist&.user&.full_name
        )
        cus_id = cus.id
      end
      card = Stripe::Customer.create_source(cus_id, source: params[:stripeToken])

      current_specialist&.payment_sources&.create!(
        stripe_customer_id: cus_id,
        stripe_card_id: card.id,
        brand: card.brand,
        exp_month: card.exp_month,
        exp_year: card.exp_year,
        last4: card.last4,
        primary: current_specialist&.payment_sources&.length&.zero?
      )
      message = ''
      code = :created
    rescue => e
      message = e.message
      code = :unprocessable_entity
    end
    resp = { message: message }
    resp[:redirectTo] = specialists_settings_payment_path

    respond_to do |format|
      format.json { render json: resp, status: code }
    end
  end

  def delete_card
    current_specialist&.payment_sources&.destroy(params[:id])

    redirect_to specialists_settings_payment_path
  end

  def make_primary
    @source = current_specialist&.payment_sources&.find(params[:id])
    @source.make_primary!
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
    %i[
      account_type
      country
      account_currency
      account_routing_number
      account_number
      address1
      zipcode
      city
      state
      country
      first_name
      last_name
      dob
      ssn_last_4
      personal_id_number
      personal_address1
      personal_zipcode
      personal_city
      additional_owners
      verification_document_data
      verification_document_cache
      business_name
      business_tax_id
    ]
  end
end
