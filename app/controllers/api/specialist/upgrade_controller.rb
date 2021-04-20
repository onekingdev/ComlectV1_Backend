# frozen_string_literal: true

class Api::Specialist::UpgradeController < ApiController
  before_action :require_specialist!
  before_action :find_payment_source, only: :subscribe

  def subscribe
    specialist_plan_name = turnkey_params[:plan]&.parameterize
    respond_with errors: { plan: 'Wrong plan name' } and return unless Subscription::SPECIALIST_PLANS.include?(specialist_plan_name)
    respond_with errors: { subscribe: 'No payment source' } and return unless @payment_source
    respond_with errors: { subscribe: 'You have already subscibed to this plan' } and return if active_subscription

    db_subscription = Subscription.create(
      plan: specialist_plan_name,
      specialist_id: current_specialist.id,
      title: 'Compliance Command Center',
      specialist_payment_source: @payment_source
    )

    if db_subscription&.stripe_subscription_id.blank?
      sub = Subscription.subscribe(
        specialist_plan_name,
        @payment_source.stripe_customer_id,
        period_ends: (Time.now.utc + 1.year).to_i
      )
      db_subscription.update(
        stripe_subscription_id: sub.id,
        billing_period_ends: sub.created
      )
    end

    respond_with message: { message: 'You have successfully subscribed' }, status: :created
  rescue Stripe::StripeError => e
    respond_with message: { message: e.message }, status: :unprocessable_entity and return
  end

  def cancel
    respond_with errors: { subscription: 'You don\'t have any subsriptions' } and return unless active_subscription

    Stripe::CancelSubscription.call(active_subscription.stripe_subscription_id)
    active_subscription.update(status: Subscription.statuses['canceled'])

    respond_with message: { message: 'Subscription was canceled' }, status: :ok
  rescue Stripe::StripeError => e
    respond_with message: { message: e.message }, status: :unprocessable_entity and return
  end

  private

  def turnkey_params
    params.permit(:plan)
  end

  def find_payment_source
    @payment_source ||= current_specialist.payment_sources.find_by(id: params[:payment_source_id])
  end

  def active_subscription
    @active_subscription ||= current_specialist.subscriptions.find_by(status: Subscription.statuses['active'])
  end
end
