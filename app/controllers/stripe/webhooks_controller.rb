# frozen_string_literal: true
class Stripe::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    StripeEventJob.perform_later params[:id], params[:user_id], connect: params[:connect] == '1'
    render nothing: true, status: :ok
  end
end
