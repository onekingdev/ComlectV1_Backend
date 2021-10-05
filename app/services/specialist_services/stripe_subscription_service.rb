# frozen_string_literal: true

# Specialist plans:
# 1 => 'free' => 'Free Plan'
# 2 => 'specialist_pro' => 'All Access Membership'

# Cases:
# 1. Free (Jul 12) => All Access Membership Annual (Oct 12)
#    User charged $400 on Oct 12. Charges again every year on Oct 12
#
# 2. All Access Membership Annual (Jul 12) => Free (Oct 12)
#    User charged $400 on Jul 12. Subscription cancelled on Oct 12. No refunds

module SpecialistServices
  class StripeSubscriptionService < ApplicationService
    attr_reader :specialist, :plan, :error, :subscription, :coupon_id

    def initialize(specialist, params)
      @specialist = specialist
      @plan = params[:plan]

      @success = true
      @coupon_id = params[:coupon_id]
    end

    def call
      begin
        ActiveRecord::Base.transaction do
          return self if plan_name_wrong?
          return self if plan_already_subscribed?
          return self if free_plan? && subscribe_free_plan
          return self if payment_source_missing?
          return self if create_pro_subscription
        end
      rescue Stripe::StripeError => e
        handle_stripe_error(e.message)
      rescue => e
        assign_error(e.message)
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

    def plan_name_wrong?
      plan_exist = Subscription::SPECIALIST_PLANS.include?(plan)
      plan_exist ? false : assign_error('Wrong plan name')
    end

    def free_plan?
      plan == 'free'
    end

    def payment_source
      @payment_source ||= specialist.default_payment_source
    end

    def active_subscription
      @active_subscription ||= specialist.subscriptions.active.first
    end

    def dashboard_unlocked!
      specialist.update(dashboard_unlocked: true)
    end

    def subscribe_free_plan
      cancel_active_subscription if active_subscription.present?
      create_free_subscription
      dashboard_unlocked!
    end

    def create_free_subscription
      @subscription = Subscription.create(
        plan: plan,
        local: true,
        quantity: 1,
        kind_of: :ccc,
        auto_renew: true,
        specialist_id: specialist.id,
        title: Subscription::PLAN_NAMES[plan]
      )
    end

    def payment_source_missing?
      payment_source.present? ? false : assign_error('No payment source')
    end

    def create_pro_subscription
      cancel_active_subscription if active_subscription.present?
      create_subscription
      commit_subscription
    end

    def create_subscription
      @subscription = Subscription.create(
        plan: plan,
        quantity: 1,
        kind_of: :ccc,
        auto_renew: true,
        specialist_id: specialist.id,
        title: Subscription::PLAN_NAMES[plan],
        specialist_payment_source: payment_source
      )
    end

    def stripe_customer
      @stripe_customer ||= specialist.stripe_customer
    end

    def commit_subscription
      @stripe_subscription = Subscription.subscribe(
        subscription.plan,
        stripe_customer,
        coupon: coupon_id,
        cancel_at_period_end: false,
        quantity: subscription.quantity
      )

      cancel_at = @stripe_subscription.cancel_at
      subscription.update(
        interval: @stripe_subscription.plan.interval,
        currency: @stripe_subscription.plan.currency,
        stripe_subscription_id: @stripe_subscription.id,
        amount: @stripe_subscription.plan.amount_decimal,
        billing_period_ends: cancel_at ? Time.zone.at(cancel_at) : nil,
        next_payment_date: Time.zone.at(@stripe_subscription.current_period_end)
      )

      dashboard_unlocked!
    end

    def plan_already_subscribed?
      return false if active_subscription.blank?

      plan_equal = active_subscription.plan == plan

      if plan_equal
        msg = "You have already subscribed to '#{active_subscription.title}'"
        assign_error(msg)
      else
        false
      end
    end

    def cancel_active_subscription
      if active_subscription.plan == 'free'
        active_subscription.update(status: 'canceled')
      end

      active_subscription.cancel!
    end
  end
end
