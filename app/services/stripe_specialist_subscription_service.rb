# frozen_string_literal: true

# Specialist plans:
# 1 => 'free'
# 2 => 'specialist_pro'

# Cases for specialist:
# 1. Free (Jul 12) => All Access Membership Annual (Oct 12)
#    User charged $400 on Oct 12. Charges again every year on Oct 12
#
# 2. All Access Membership Annual (Jul 12) => Free (Oct 12)
#    User charged $400 on Jul 12. Subscription cancelled on Oct 12. No refunds

class StripeSpecialistSubscriptionService < ApplicationService
  attr_reader :current_specialist, :new_plan, :error, :subscription

  def initialize(current_specialist, turnkey_params)
    @current_specialist = current_specialist
    @new_plan = turnkey_params[:plan]
    @success = true
  end

  def call
    begin
      return self if plan_name_invalid?
      return self if free_plan? && subscribe_free_plan
      return self if payment_source_missing?

      return self if active_subscription.blank? && create_new_subscription
      return self if nothing_to_change?
    rescue Stripe::StripeError => e
      handle_stripe_error(e.message)
    end

    self
  end

  def success?
    @success
  end

  private

  def handle_stripe_error(error_msg)
    @success = false
    @error = error_msg
  end

  def assign_error(error_msg)
    @error = error_msg
    @success = false
    true
  end

  def plan_name_invalid?
    plan_exist = Subscription::SPECIALIST_PLANS.include?(new_plan)
    plan_exist ? false : assign_error('Wrong plan name')
  end

  def free_plan?
    new_plan == 'free'
  end

  def payment_source
    @payment_source ||= current_specialist.default_payment_source
  end

  def active_subscription
    @active_subscription ||= current_specialist.subscriptions.active.first
  end

  def dashboard_unlocked!
    current_specialist.update(dashboard_unlocked: true)
  end

  def subscribe_free_plan
    cancel_subscription if active_subscription.present?
    dashboard_unlocked!
  end

  def cancel_subscription
    Stripe::CancelSubscription.call(active_subscription.stripe_subscription_id)
    active_subscription.update(status: Subscription.statuses['canceled'])
  end

  def payment_source_missing?
    payment_source.present? ? false : assign_error('No payment source')
  end

  def create_new_subscription
    create_subscription
    commit_subscription
  end

  def create_subscription
    @subscription = Subscription.create(
      quantity: 1,
      kind_of: :ccc,
      plan: new_plan,
      auto_renew: true,
      title: 'All Access Membership',
      specialist_id: current_specialist.id,
      specialist_payment_source: payment_source
    )
  end

  def stripe_customer
    @stripe_customer ||= current_specialist.stripe_customer
  end

  def commit_subscription
    @stripe_subscription = Subscription.subscribe(
      subscription.plan,
      stripe_customer,
      cancel_at_period_end: false,
      quantity: subscription.quantity
    )

    subscription.update(
      stripe_subscription_id: @stripe_subscription.id,
      billing_period_ends: @stripe_subscription.cancel_at
    )

    dashboard_unlocked!
  end

  def nothing_to_change?
    plan_equal = active_subscription.plan == new_plan
    plan_equal ? assign_error('You have already subscribed to this plan') : false
  end
end
