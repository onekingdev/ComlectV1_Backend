# frozen_string_literal: true

class Api::Specialist::UpgradeController < ApiController
  before_action :require_specialist!

  def subscribe
    service = StripeSpecialistSubscriptionService.call(current_specialist, turnkey_params)

    if service.success?
      respond_with message: I18n.t('api.specialist.upgrade.subscribe_success'), status: :created
    else
      render json: { message: service.error }, status: :unprocessable_entity
    end
  end

  def cancel
    respond_with(
      errors: { subscription: I18n.t('api.specialist.upgrade.no_subscription_to_cancel') }
    ) && return unless active_subscription

    Stripe::CancelSubscription.call(active_subscription.stripe_subscription_id)
    active_subscription.update(status: Subscription.statuses['canceled'])

    respond_with message: { message: I18n.t('api.specialist.upgrade.cancelled') }, status: :ok
  rescue Stripe::StripeError => e
    respond_with(message: { message: e.message }, status: :unprocessable_entity) && (return)
  end

  private

  def turnkey_params
    params.require(:upgrade).permit(:plan, :payment_source_id, :coupon_id)
  end

  def active_subscription
    @active_subscription ||=
      current_specialist.subscriptions.find_by(status: Subscription.statuses['active'])
  end
end
