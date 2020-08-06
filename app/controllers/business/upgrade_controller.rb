# frozen_string_literal: true

class Business::UpgradeController < ApplicationController
  include SubscriptionCommon

  def index
    @payment_source = payment_source
  end

  def buy; end

  def subscribe
    begin
      raise "no payment source. Check <a href='#{business_settings_payment_index_path}'>payments settings</a>" unless payment_source
      raise 'wrong plan' unless Subscription.plans.key?(turnkey_params[:plan]&.parameterize)

      db_subscription = current_business.subscriptions.base.presence || Subscription.create(
        plan: turnkey_params[:plan]&.parameterize,
        business_id: current_business.id,
        title: 'Compliance Command Center',
        payment_source: payment_source
      )

      add_one_time_payment(db_subscription)

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
    rescue => e
      message = e.message
      code = :unprocessable_entity
    end
    respond_to do |format|
      format.json { render json: { message: message }, status: code }
    end
  end

  private

  def turnkey_params
    params.require(:turnkey).permit(:plan)
  end

  def payment_source
    current_business.payment_profile.default_payment_source
  end

  def stripe_customer
    current_business.payment_profile.stripe_customer
  end
end
