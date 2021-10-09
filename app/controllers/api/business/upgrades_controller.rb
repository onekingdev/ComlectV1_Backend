# frozen_string_literal: true

class Api::Business::UpgradesController < ApiController
  before_action :require_business!

  def create
    service = BusinessServices::StripeSubscriptionService.call(
      current_business, payment_source, upgrade_params
    )

    if service.success?
      plan_name = service.subscriptions.first.title

      render json: {
        message: t('.notice', plan_name: plan_name),
        processed: serialize_subs(service.subscriptions)
      }, status: :created
    else
      render json: { error: service.error }, status: :unprocessable_entity
    end
  end

  private

  def payment_source
    current_business.payment_profile&.default_payment_source
  end

  def upgrade_params
    params.require(:upgrade).permit(:plan, :seats_count, :payment_source_id, :coupon_id)
  end

  def serialize_subs(subs)
    subs.map(&proc { |psub| Business::SubscriptionSerializer.new(psub).serializable_hash })
  end
end
