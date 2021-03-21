# frozen_string_literal: true

class Api::Business::UpgradeController < ApiController
  before_action :require_business!

  def subscribe
    respond_with errors: { plan: 'Wrong plan name' } and return unless Subscription.plans.key?(turnkey_params[:plan]&.parameterize)
    respond_with errors: { subscribe: 'No payment source' } and return unless payment_source
    active_subscription = current_business.subscriptions.find_by(status: Subscription.statuses['active'])

    begin
      cancel_subscription(active_subscription) if active_subscription

      db_subscription = Subscription.create(
        plan: turnkey_params[:plan]&.parameterize,
        business_id: current_business.id,
        title: 'Compliance Command Center',
        payment_source: payment_source
      )

      if db_subscription&.stripe_subscription_id.blank?
        sub = Subscription.subscribe(
          turnkey_params[:plan]&.parameterize,
          stripe_customer,
          period_ends: (Time.now.utc + 1.year).to_i
        )
        db_subscription.update(
          stripe_subscription_id: sub.id,
          billing_period_ends: sub.created
        )
      end

      message = 'subscribed'
      code = :created
    rescue Stripe::StripeError => e
      respond_with message: { message: e.message }, status: :unprocessable_entity and return
    end

    respond_with message: { message: message }, status: code
  end

  private

  def cancel_subscription(active_subscription)
    Stripe::CancelSubscription.call(active_subscription.stripe_subscription_id)
    active_subscription.update(status: Subscription.statuses['canceled'])
  end

  def turnkey_params
    params.require(:turnkey).permit(:plan)
  end

  def payment_source
    @payment_source ||= current_business.payment_profile.payment_sources.find(params[:payment_source_id])
  end

  def stripe_customer
    current_business.payment_profile.stripe_customer
  end
end
