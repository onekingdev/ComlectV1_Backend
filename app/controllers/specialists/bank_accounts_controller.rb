# frozen_string_literal: true
class Specialists::BankAccountsController < ApplicationController
  before_action :require_specialist!
  before_action :require_stripe_account!

  def new
    @bank_account = BankAccount::Create.new(stripe_account: stripe_account)
  end

  def create
    @bank_account = BankAccount::Create.new(permitted_params.merge(stripe_account: stripe_account))
    if @bank_account.save
      redirect_to specialists_settings_payment_path
    else
      render :new
    end
  end

  def make_primary
    @bank_account = BankAccount::Update.retrieve(stripe_account, params[:bank_account_id])
    @bank_account.make_primary!
    redirect_to specialists_settings_payment_path
  end

  def destroy
    @bank_account = stripe_account.bank_accounts.find(params[:id])
    authorize @bank_account, :destroy?
    @bank_account.destroy
    redirect_to specialists_settings_payment_path
  end

  private

  def permitted_params
    params.require(:bank_account).permit(:currency, :account_number, :routing_number)
  end

  def require_stripe_account!
    return if stripe_account.present?
    redirect_to specialists_settings_payment_path, notice: 'Please first add your personal details'
  end

  def stripe_account
    @_stripe_account ||= current_specialist.stripe_account
  end
end
