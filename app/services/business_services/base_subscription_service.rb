# frozen_string_literal: true

module BusinessServices
  class BaseSubscriptionService < ApplicationService
    attr_accessor :subscriptions

    attr_reader \
      :business, :payment_source, :params, :error,
      :plan_seat_count, :plan, :coupon_id, :free_subscription

    def initialize(business, payment_source, params)
      @business = business
      @payment_source = payment_source
      @params = params

      @success = true
      @subscriptions = []
      @plan = params[:plan]
      @coupon_id = params[:coupon_id]

      set_plan_seat_count
    end

    def success?
      @success
    end

    private

    def set_plan_seat_count
      @plan_seat_count = Seat::FREE_SEAT_COUNT and return if free_plan?

      @plan_seat_count = params[:seats_count].to_i
      @plan_seat_count = free_seat_count if plan_seat_count.zero? && plan.present?
    end

    def handle_stripe_error(error_msg)
      @success = false
      @error = error_msg
    end

    def plan_name_wrong?
      plan_exist = Subscription.plans.key?(params[:plan]&.parameterize)
      plan_exist ? false : assign_error('Wrong plan name')
    end

    def assign_error(error_msg)
      @error = error_msg
      @success = false
      true
    end

    def free_plan?
      plan == 'free'
    end

    def subscribe_free_plan
      cancel_active_subscriptions if active_subscriptions.present?
      create_free_subscription
      onboarding_passed!
    end

    def create_free_subscription
      subscription = Subscription.create(
        plan: plan,
        local: true,
        kind_of: :ccc,
        auto_renew: true,
        business_id: business.id,
        quantity: plan_seat_count,
        title: Subscription::PLAN_NAMES[plan]
      )

      create_seats(subscription, plan_seat_count)
      @subscriptions.push(subscription)
    end

    def active_subscriptions
      @active_subscriptions = business.subscriptions.active
    end

    def paid_subscriptions_blank?
      subs = active_subscriptions
      subs.blank? || (subs.count == 1 && subs.last.free? && @free_subscription = subs.last)
    end

    def cancel_active_subscriptions
      active_subscriptions.each do |subscription|
        seats = subscription.seats
        destroy_seats(seats)
        subscription.cancel!
      end
    end

    def destroy_seats(seats)
      seats.each do |seat|
        if seat.team_member_id.present?
          invitation = Specialist::Invitation.find_by(team_member_id: seat.team_member_id)
        end

        Seat.transaction do
          seat.unassign if seat.assigned_at.present?

          if invitation.present? && invitation.specialist.present?
            invitation.specialist.update(dashboard_unlocked: false)
          end
        end

        seat.destroy
      end
    end

    def payment_source_missing?
      payment_source.present? ? false : assign_error('No payment source')
    end

    def create_new_subscriptions
      cancel_active_subscriptions if free_subscription.present?

      create_primary_subscription
      create_seat_subscription if plan_has_additional_seats?
      commit_subscriptions
      onboarding_passed!
    end

    def onboarding_passed!
      assign_seat_to_owner
      business.update(onboarding_passed: true)
    end

    def assign_seat_to_owner
      free_seat = business.available_seat
      owner = business.team_member
      free_seat.assign_to(owner.id)
    end

    def create_primary_subscription(with_commit: false, with_seats: false)
      @primary_subscription = Subscription.create(
        plan: plan,
        quantity: 1,
        kind_of: :ccc,
        auto_renew: true,
        business_id: business.id,
        payment_source: payment_source,
        title: Subscription::PLAN_NAMES[plan]
      )

      subscriptions.push(@primary_subscription)
      commit_subscriptions(add_seats: with_seats) if with_commit
    end

    def plan_has_additional_seats?
      plan_seat_count > free_seat_count
    end

    def create_seat_subscription(with_commit: false, quantity: nil, with_seats: true)
      quantity ||= plan_seat_count - free_seat_count
      plan_name = annual_plan? ? 'seats_annual' : 'seats_monthly'

      @seat_subscription = Subscription.create(
        kind_of: :seats,
        plan: plan_name,
        auto_renew: true,
        quantity: quantity,
        business_id: business.id,
        payment_source: payment_source,
        title: Subscription::PLAN_NAMES[plan_name]
      )

      subscriptions.push(@seat_subscription)
      commit_subscriptions(add_seats: with_seats) if with_commit
    end

    def annual_plan?
      plan.include?('annual')
    end

    def commit_subscriptions(add_seats: true)
      subscriptions.each do |subscription|
        stripe_subscription = Subscription.subscribe(
          subscription.plan,
          stripe_customer_id,
          coupon: coupon_id,
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

    def stripe_customer_id
      @stripe_customer_id ||= business.payment_profile.stripe_customer_id
    end

    def free_seat_count
      if plan.include?('business_tier_')
        Seat::FREE_BUSINESS_SEAT_COUNT
      else
        Seat::FREE_TEAM_SEAT_COUNT
      end
    end

    def create_seats(subscription, seat_count)
      seat_count.times do
        Seat.create(
          business_id: business.id,
          subscribed_at: Time.now.utc,
          subscription_id: subscription.id
        )
      end
    end

    def action_name
      upgrade_account? ? 'upgrade' : 'downgrade'
    end

    def upgrade_account?
      plans = Subscription::BUSINESS_PLANS
      plans.key(plan) > plans.key(primary_subscription.plan)
    end

    def primary_subscription
      @primary_subscription = active_subscriptions.where(kind_of: 'ccc').first
    end

    def current_plan
      primary_subscription.plan
    end

    def upgrade_to_new_plan
      cancel_active_subscriptions
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
      if plan_seat_count > db_seat_count
        upgrade_seat_count(with_cancelation: true)
      else
        downgrade_seat_count
      end
    end

    def retrieve_stripe_subscription
      stripe_subscription_id = primary_subscription.stripe_subscription_id
      @stripe_subscription = Stripe::Subscription.retrieve(stripe_subscription_id)
    end

    def new_price_id
      Subscription.get_plan_id(plan)
    end

    def update_db_primary_subscription
      primary_subscription.update(
        plan: plan,
        auto_renew: true,
        title: Subscription::PLAN_NAMES[plan]
      )
    end

    def downgrade_subscription
      cancel_active_subscriptions
      create_new_subscriptions
    end

    def reduce_seats(subscription, number)
      seats = Seat.order(created_at: :desc).where(subscription_id: subscription.id).limit(number)
      destroy_seats(seats)
    end

    def downgrade_to_new_plan_with_refund
      refund_charges
      cancel_active_subscriptions
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
        customer: stripe_customer_id,
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

      return unless prorated_amount.positive?

      latest_invoice = Stripe::Invoice.retrieve(@stripe_subscription.latest_invoice)
      latest_charge_id = latest_invoice.charge

      Stripe::Refund.create(
        charge: latest_charge_id,
        amount:  prorated_amount
      )
    end

    def primary_plan_change?
      primary_subscription.plan != params[:plan]
    end

    def db_seat_count
      @db_seat_count = Seat.where(subscription_id: active_subscriptions.ids).count
    end

    def seat_count_change?
      db_seat_count != plan_seat_count
    end

    def plan_already_subscribed?
      return false if active_subscriptions.blank?

      if !primary_plan_change? && !seat_count_change?
        msg = "You have already subscribed to '#{primary_subscription.title}'"
        assign_error(msg)
      end
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
      seats = seat_subscription.seats
      destroy_seats(seats)
      seat_subscription.cancel!
    end

    def reduce_paid_seats(count)
      seats = seat_subscription.seats.order(created_at: :desc).limit(count)
      downgrade_seat_subscription(count)
      destroy_seats(seats)
    end

    def downgrade_seat_subscription(count)
      quantity = seat_subscription.quantity - count

      Stripe::Subscription.update(
        retrieve_stripe_seat_subscription.id,
        proration_behavior: :none,
        items: [
          {
            quantity: quantity,
            id: @stripe_seat_subscription.items.data[0].id
          }
        ]
      )

      seat_subscription.update(quantity: quantity)
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
end
