# frozen_string_literal: true

class Api::Business::UpgradeController < ApiController
  before_action :require_business!
  skip_before_action :verify_authenticity_token

  def subscribe
    service = StripeBusinessSubscriptionService.call(
      current_business, payment_source, turnkey_params
    )

    if service.success?
      render json: {
        message: 'subscribed',
        processed: serialize_subs(service.subscriptions)
      }, status: :created
    else
      render json: {
        error: service.error,
        processed: serialize_subs(service.subscriptions)
      }, status: :unprocessable_entity
    end
  end

  private

  def turnkey_params
    params.permit(:plan, :seats_count)
  end

  def payment_source
    current_business.payment_profile&.default_payment_source
  end

  def serialize_subs(subs)
    subs.map(&proc { |psub| SubscriptionSerializer.new(psub).serializable_hash })
  end
end
