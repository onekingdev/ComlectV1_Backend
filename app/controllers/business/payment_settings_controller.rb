# frozen_string_literal: true
class Business::PaymentSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_business!
  skip_before_action :verify_authenticity_token, only: :create

  def index
    @sources = current_user.business.payment_profile&.payment_sources&.sorted || []
  end

  def create
    PaymentSource.add_to current_user.business, token: params[:stripeToken]
    redirect_to business_settings_payment_index_path
  end

  def update
    @source = current_user.business.payment_profile.payment_sources.find(params[:id])
    @source.update_from_stripe params[:stripeToken]
    redirect_to business_settings_payment_index_path
  end

  def make_primary
    @source = current_user.business.payment_profile.payment_sources.find(params[:payment_id])
    @source.make_primary!
    redirect_to business_settings_payment_index_path
  end

  def destroy
    @source = current_user.business.payment_profile.payment_sources.find(params[:id])
    @source.destroy
    redirect_to business_settings_payment_index_path
  end
end
