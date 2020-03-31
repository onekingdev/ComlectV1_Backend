# frozen_string_literal: true

class Business::ChargesController < ApplicationController
  before_action :require_business!
  before_action :require_payment_profile!

  def create
    Business::OneOffCharge.for(current_business).process!(
      amount_in_cents: charge_params[:amount_in_cents].to_i,
      description: charge_params[:description]
    )

    render nothing: true, status: :created
  end

  private

  def charge_params
    params.require(:charge).permit(:amount_in_cents, :description)
  end

  def require_payment_profile!
    return if current_business.payment_profile.present?
    render_403
  end
end
