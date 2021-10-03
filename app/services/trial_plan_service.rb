# frozen_string_literal: true

# Close existing subscription and assign new trial subscription

class TrialPlanService < ApplicationService
  attr_reader :source, :plan, :trial_end, :error, :local

  # source: business || specialist
  # plan: 'business_tier_annual' or other
  # trial_end: 1643587200 Unix timestamp (https://www.unixtimestamp.com/)

  # local: true, creates plan locally only in our db for trial period
  # This case is good choice for user who does not have payment info
  # WARN: active subscription will be closed in stripe and in our db

  def initialize(source:, plan:, trial_end:, local:)
    @source = source
    @plan = plan
    @trial_end = trial_end
    @local = local

    @success = true
  end

  def call
    cancel_subscriptions

    assign_trial_plan_for_business if source.business?
    assign_trial_plan_for_specialist if source.specialist?
  rescue => e
    @success = false
    @error = e.message
  end

  def success?
    @success
  end

  private

  def cancel_subscriptions
    subscriptions = source.subscriptions.active

    subscriptions.each do |subscription|
      cancel(subscription)
    end
  end

  def cancel(subscription)
    Stripe::CancelSubscription.call(subscription.stripe_subscription_id)
    subscription.update(status: 'canceled')
  end

  def assign_trial_plan_for_business
    seats = source.seats
    payment_source = source.payment_profile&.default_payment_source
    stripe_customer_id = source.payment_profile&.stripe_customer_id

    subscription = Subscription.create(
      plan: plan,
      quantity: 1,
      local: local,
      kind_of: :ccc,
      currency: 'usd',
      auto_renew: true,
      interval: 'year',
      business_id: source.id,
      payment_source: payment_source,
      trial_end: Time.zone.at(trial_end),
      title: Subscription::PLAN_NAMES[plan],
      next_payment_date: Time.zone.at(trial_end)
    )

    subscribe(subscription, stripe_customer_id) unless local
    seats.each { |seat| seat.update_attribute(:subscription_id, subscription.id) }

    if seats.size < free_seat_count
      seat_count = free_seat_count - seats.size
      create_seats(subscription, seat_count)
    end
  end

  def subscribe(subscription, stripe_customer_id)
    stripe_subscription = Subscription.subscribe(
      subscription.plan,
      stripe_customer_id,
      trial_end: trial_end,
      cancel_at_period_end: false,
      quantity: subscription.quantity
    )

    cancel_at = stripe_subscription.cancel_at
    subscription.update(
      interval: stripe_subscription.plan.interval,
      currency: stripe_subscription.plan.currency,
      stripe_subscription_id: stripe_subscription.id,
      amount: stripe_subscription.plan.amount_decimal,
      billing_period_ends: cancel_at ? Time.zone.at(cancel_at) : nil,
      next_payment_date: Time.zone.at(stripe_subscription.current_period_end)
    )
  end

  def free_seat_count
    if plan.include?('business')
      Seat::FREE_BUSINESS_SEAT_COUNT
    else
      Seat::FREE_TEAM_SEAT_COUNT
    end
  end

  def create_seats(subscription, seat_count)
    seat_count.times do
      Seat.create(
        business_id: source.id,
        subscribed_at: Time.now.utc,
        subscription_id: subscription.id
      )
    end
  end

  def assign_trial_plan_for_specialist
    payment_source = source.default_payment_source

    Subscription.create(
      plan: plan,
      quantity: 1,
      local: local,
      kind_of: :ccc,
      currency: 'usd',
      interval: 'year',
      auto_renew: true,
      specialist_id: source.id,
      trial_end: Time.zone.at(trial_end),
      title: Subscription::PLAN_NAMES[plan],
      next_payment_date: Time.zone.at(trial_end),
      specialist_payment_source_id: payment_source
    )
  end
end
