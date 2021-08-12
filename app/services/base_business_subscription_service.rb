# frozen_string_literal: true

class BaseBusinessSubscriptionService < ApplicationService
  attr_accessor :subscriptions

  attr_reader \
    :current_business, :payment_source,
    :turnkey_params, :plan_seat_count, :error, :new_plan, :coupon

  def initialize(current_business, payment_source, turnkey_params)
    @current_business = current_business
    @payment_source = payment_source
    @turnkey_params = turnkey_params

    @success = true
    @subscriptions = []
    @new_plan = turnkey_params[:plan]
    @coupon = turnkey_params[:coupon]
    set_plan_seat_count
  end

  def success?
    @success
  end

  private

  def set_plan_seat_count
    @plan_seat_count = turnkey_params[:seats_count].to_i
    @plan_seat_count = free_seat_count if plan_seat_count.zero? && new_plan.present?
  end

  def handle_stripe_error(error_msg)
    @success = false
    @error = error_msg
  end

  def plan_name_invalid?
    plan_exist = Subscription.plans.key?(turnkey_params[:plan]&.parameterize)
    plan_exist ? false : assign_error('Wrong plan name')
  end

  def assign_error(error_msg)
    @error = error_msg
    @success = false
    true
  end

  def free_plan?
    new_plan == 'free'
  end

  def subscribe_free_plan
    cancel_subscriptions if active_subscriptions.present?
    onboarding_passed!
  end

  def active_subscriptions
    @active_subscriptions = current_business.subscriptions.active
  end

  def cancel_subscriptions
    active_subscriptions.each do |subscription|
      seats = Seat.where(subscription_id: subscription.id)

      destroy_seats(seats)
      cancel(subscription)
    end
  end

  def destroy_seats(seats)
    seats.each do |seat|
      invitation = Specialist::Invitation.find_by(email: seat&.team_member&.email)

      begin
        Seat.transaction do
          seat&.unassign
          invitation&.specialist&.update!(dashboard_unlocked: false)
        end
        seat.destroy
      rescue => e
        Rails.logger.error(e.message)
      end
    end
  end

  def cancel(subscription)
    Stripe::CancelSubscription.call(subscription.stripe_subscription_id)
    subscription.update(status: Subscription.statuses['canceled'])
  end

  def payment_source_missing?
    payment_source.present? ? false : assign_error('No payment source')
  end

  def create_new_subscriptions
    create_primary_subscription
    create_seat_subscription if plan_has_additional_seats?
    commit_subscriptions
    onboarding_passed!
  end

  def onboarding_passed!
    current_business.update(onboarding_passed: true)
  end

  def create_primary_subscription(with_commit: false, with_seats: false)
    @primary_subscription = Subscription.create(
      quantity: 1,
      kind_of: :ccc,
      plan: new_plan,
      auto_renew: true,
      title: new_plan.titleize,
      payment_source: payment_source,
      business_id: current_business.id
    )

    subscriptions.push(@primary_subscription)
    commit_subscriptions(add_seats: with_seats) if with_commit
  end

  def plan_has_additional_seats?
    plan_seat_count > free_seat_count
  end

  def create_seat_subscription(with_commit: false, quantity: plan_seat_count - free_seat_count, with_seats: true)
    @seat_subscription = Subscription.create(
      kind_of: :seats,
      auto_renew: true,
      quantity: quantity,
      title: 'Seats subscription',
      payment_source: payment_source,
      business_id: current_business.id,
      plan: annual_plan? ? 'seats_annual' : 'seats_monthly'
    )

    subscriptions.push(@seat_subscription)
    commit_subscriptions(add_seats: with_seats) if with_commit
  end

  def annual_plan?
    new_plan.include?('annual')
  end

  def commit_subscriptions(add_seats: true)
    subscriptions.each do |subscription|
      stripe_subscription = Subscription.subscribe(
        subscription.plan,
        stripe_customer,
        coupon: coupon,
        cancel_at_period_end: false,
        quantity: subscription.quantity
      )

      subscription.update(
        stripe_subscription_id: stripe_subscription.id,
        billing_period_ends: stripe_subscription.cancel_at
      )

      next unless add_seats
      seat_count =
        if subscription.kind_of == 'ccc'
          plan_seat_count > free_seat_count ? free_seat_count : plan_seat_count
        else
          subscription.quantity
        end
      create_seats(subscription, seat_count)
    end
  end

  def stripe_customer
    @stripe_customer ||= current_business.payment_profile.stripe_customer
  end

  def free_seat_count
    new_plan.include?('business_tier_') ? 10 : 3
  end

  def create_seats(subscription, seat_count)
    seat_count.times do
      Seat.create(
        subscribed_at: Time.now.utc,
        business_id: current_business.id,
        subscription_id: subscription.id
      )
    end
  end

  def action_name
    upgrade_account? ? 'upgrade' : 'downgrade'
  end

  def upgrade_account?
    plans = Subscription::BUSINESS_PLANS
    plans.key(new_plan) > plans.key(primary_subscription.plan)
  end

  def primary_subscription
    @primary_subscription = active_subscriptions.where(kind_of: 'ccc').first
  end

  def current_plan
    primary_subscription.plan
  end

  def upgrade_to_new_plan
    cancel_subscriptions
    create_new_subscriptions
  end

  def upgrade_subscription
    Stripe::Subscription.update(
      retrieve_stripe_subscription.id,
      proration_behavior: :none,
      cancel_at_period_end: false,
      items: [
        {
          price: new_price_id,
          id: @stripe_subscription.items.data[0].id
        }
      ]
    )

    update_db_primary_subscription
    recalculate_seats
  end

  def recalculate_seats
    plan_seat_count > db_seat_count ? upgrade_seat_count(with_cancelation: true) : downgrade_seat_count
  end

  def retrieve_stripe_subscription
    stripe_subscription_id = primary_subscription.stripe_subscription_id
    @stripe_subscription = Stripe::Subscription.retrieve(stripe_subscription_id)
  end

  def new_price_id
    Subscription.get_plan_id(new_plan)
  end

  def update_db_primary_subscription
    primary_subscription.update(
      plan: new_plan,
      auto_renew: true,
      title: new_plan.titleize
    )
  end

  def downgrade_subscription
    cancel_subscriptions
    create_new_subscriptions
  end

  def reduce_seats(subscription, number)
    seats = Seat.order(created_at: :desc).where(subscription_id: subscription.id).limit(number)
    destroy_seats(seats)
  end

  def downgrade_to_new_plan_with_refund
    refund_charges
    cancel_subscriptions
    create_new_subscriptions
  end

  def refund_charges
    items = [{
      quantity: 0,
      id: retrieve_stripe_subscription.items.data[0].id,
      plan: @stripe_subscription.items.data[0].plan.id
    }]

    # For test purpose
    # proration_date = (Time.now.utc + 2.months + 10.days).to_i
    proration_date = Time.now.utc.to_i

    invoice = Stripe::Invoice.upcoming(
      customer: stripe_customer,
      subscription_items: items,
      subscription: @stripe_subscription,
      subscription_proration_date: proration_date
    )

    prorated_amount = 0
    invoice.lines.data.each do |i|
      if i.type == 'invoiceitem'
        prorated_amount = i.amount.negative? ? i.amount.abs : 0
        break
      end
    end

    latest_invoice = Stripe::Invoice.retrieve(@stripe_subscription.latest_invoice)
    latest_charge_id = latest_invoice.charge

    return unless prorated_amount.positive?
    Stripe::Refund.create(
      charge: latest_charge_id,
      amount:  prorated_amount
    )
  end

  def primary_plan_change?
    primary_subscription.plan != turnkey_params[:plan]
  end

  def db_seat_count
    @db_seat_count = Seat.where(subscription_id: active_subscriptions.ids).count
  end

  def seat_count_change?
    db_seat_count != plan_seat_count
  end

  def nothing_to_change?
    !primary_plan_change? && !seat_count_change?
  end

  def only_seat_count_change?
    !primary_plan_change? && seat_count_change?
  end

  def update_seats
    plan_seat_count > db_seat_count ? upgrade_seat_count : downgrade_seat_count
  end

  def upgrade_seat_count(with_cancelation: false)
    count = plan_seat_count - db_seat_count
    left_free_seat_count = free_seat_count - db_seat_count

    if left_free_seat_count.positive?
      count -= left_free_seat_count
      total = count.positive? ? left_free_seat_count : left_free_seat_count - count.abs
      create_seats(primary_subscription, total)
    end

    if count.positive?
      if seat_subscription.blank?
        create_seat_subscription(with_commit: true, quantity: count)
      else
        with_cancelation ? cancel_and_create_seats(count) : upgrade_and_create_seats(count)
      end
    end

    true
  end

  def downgrade_seat_count
    count = db_seat_count - plan_seat_count

    if seat_subscription.present?
      count -= seat_subscription.quantity
      if count.positive? || count.zero?
        delete_all_paid_seats
      else
        reduce_paid_seats(seat_subscription.quantity - count.abs)
      end
    end

    reduce_seats(primary_subscription, count) if count.positive?
    true
  end

  def delete_all_paid_seats
    seats = Seat.where(subscription_id: seat_subscription.id)
    cancel(seat_subscription)
    destroy_seats(seats)
  end

  def reduce_paid_seats(count)
    seats = Seat.order(created_at: :desc).where(subscription_id: seat_subscription.id).limit(count)
    downgrade_seat_subscription(count)
    destroy_seats(seats)
  end

  def downgrade_seat_subscription(count)
    Stripe::Subscription.update(
      retrieve_stripe_seat_subscription.id,
      proration_behavior: :none,
      items: [
        {
          quantity: seat_subscription.quantity - count,
          id: @stripe_seat_subscription.items.data[0].id
        }
      ]
    )

    seat_subscription.update(quantity: seat_subscription.quantity - count)
  end

  def seat_subscription
    @seat_subscription = active_subscriptions.where(kind_of: 'seats').first
  end

  def upgrade_and_create_seats(count)
    Stripe::Subscription.update(
      retrieve_stripe_seat_subscription.id,
      cancel_at_period_end: false,
      proration_behavior: :always_invoice,
      items: [
        {
          quantity: seat_subscription.quantity + count,
          id: @stripe_seat_subscription.items.data[0].id
        }
      ]
    )

    seat_subscription.update(quantity: seat_subscription.quantity + count)
    create_seats(seat_subscription, count)
  end

  def cancel_and_create_seats(count)
    seats = Seat.where(subscription_id: seat_subscription.id)
    total = seat_subscription.quantity + count
    cancel(seat_subscription)
    create_seat_subscription(with_commit: true, quantity: total, with_seats: false)
    seats.update_all(subscription_id: seat_subscription.id)
    create_seats(seat_subscription, count)
  end

  def retrieve_stripe_seat_subscription
    stripe_subscription_id = seat_subscription.stripe_subscription_id
    @stripe_seat_subscription = Stripe::Subscription.retrieve(stripe_subscription_id)
  end
end
