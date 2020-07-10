# frozen_string_literal: true

class SubscriptionsController < ApplicationController
  include SubscriptionHelper

  before_action :subscription

  def cancel
    begin
      sub = Stripe::Subscription.retrieve(@subscription.stripe_subscription_id)
      sub.cancel_at = billing_date(@subscription).utc.to_i
      sub.proration_behavior = 'none'
      sub.save

      @subscription.update!(
        status: 1,
        auto_renew: false,
        billing_period_ends: sub.cancel_at
      )

      flash[:notice] = 'Successfully canceled'
    rescue => e
      flash[:error] = e.message
    end
    redirect_to business_settings_subscriptions_path
  end

  def update
    begin
      sub = Stripe::Subscription.retrieve(@subscription.stripe_subscription_id)

      sub.cancel_at = @subscription.auto_renew ? billing_date(@subscription) : nil
      sub.proration_behavior = 'none'
      sub.save

      @subscription.update!(auto_renew: !@subscription.auto_renew)

      res = { status: :ok, renew: @subscription.auto_renew }
    rescue => e
      res = { error: true, message: e.message }
    end

    respond_to do |format|
      format.json { render json: res, status: (res.key?(:error) ? :unprocessable_entity : :ok) }
    end
  end

  private

  def sub_params
    params.require(:subscription).permit(:auto_renew)
  end

  def subscription
    @subscription ||= Subscription.find_by(id: params[:id])

    redirect_to business_settings_subscriptions_path, flash: { error: 'subscription not found' } unless @subscription
  end
end
