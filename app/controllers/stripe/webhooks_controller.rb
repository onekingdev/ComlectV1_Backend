# frozen_string_literal: true
class Stripe::WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  HANDLERS = {
    'account.updated' => StripeWebhook::AccountUpdated,
    'charge.failed' => StripeWebhook::ChargeFailed
  }.freeze

  def create
    handler = HANDLERS[params[:type]]
    handler.handle(params[:id], connect: params[:connect] == '1') if handler
    render nothing: true, status: :ok
  end
end
