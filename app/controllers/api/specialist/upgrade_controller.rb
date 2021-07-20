# frozen_string_literal: true

class Api::Specialist::UpgradeController < ApiController
  before_action :require_specialist!

  def subscribe
    service = StripeSpecialistSubscriptionServise.call(current_specialist, turnkey_params)

    if service.success?
      respond_with message: 'You have successfully subscribed', status: :created
    else
      respond_with message: service.error, status: :unprocessable_entity
    end
  end

  def cancel
    respond_with(errors: { subscription: 'You don\'t have any subscriptions' }) && return unless active_subscription

    Stripe::CancelSubscription.call(active_subscription.stripe_subscription_id)
    active_subscription.update(status: Subscription.statuses['canceled'])

    respond_with message: { message: 'Subscription was cancelled' }, status: :ok
  rescue Stripe::StripeError => e
    respond_with(message: { message: e.message }, status: :unprocessable_entity) && (return)
  end

  private

  def turnkey_params
    params.permit(:plan)
  end

  def active_subscription
    @active_subscription ||= current_specialist.subscriptions.find_by(status: Subscription.statuses['active'])
  end
end
