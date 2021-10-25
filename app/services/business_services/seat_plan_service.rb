# frozen_string_literal: true

module BusinessServices
  class SeatPlanService
    def create_new_seat_subscription(business, params)
      @params = params
      @business = business
      plan_id = Subscription.get_plan_id(@params[:plan])
      payment_source = get_payment_source
      data = {
        customer: payment_source.payment_profile&.stripe_customer_id,
        items: [
          plan: plan_id,
          quantity: @params[:quantity].to_i
        ],
        default_payment_method: payment_source.stripe_id
      }
      stripe_subscription = Stripe::Subscription.create(data)
      create_new_subscription(stripe_subscription) if stripe_subscription && stripe_subscription.status == 'active'
      { subscription: @subscription, success: true }
    rescue Stripe::StripeError => e
      { subscription: nil, success: false, error: e.message }
    rescue => e
      { subscription: nil, success: false, error: e.message }
    end

    private

    def get_payment_source
      PaymentSource.find_by(id: @params[:payment_source_id])
    end

    def create_new_subscription(stripe_subscription)
      cancel_at = stripe_subscription.cancel_at
      @subscription = Subscription.create(
        business: @business,
        plan: @params[:plan].to_sym,
        kind_of: :seats,
        title: Subscription::PLAN_NAMES[@params[:plan]],
        payment_source_id: @params[:payment_source_id],
        auto_renew: true,
        status: :active,
        quantity: @params[:quantity],
        interval: stripe_subscription.plan.interval,
        currency: stripe_subscription.plan.currency,
        stripe_subscription_id: stripe_subscription.id,
        amount: stripe_subscription.plan.amount_decimal,
        billing_period_ends: cancel_at ? Time.zone.at(cancel_at) : nil,
        next_payment_date: Time.zone.at(stripe_subscription.current_period_end)
      )

      create_new_seat_slots if @subscription
    end

    def create_new_seat_slots
      seats = []
      @params[:quantity].to_i.times do |_i|
        new_seat = {
          business_id: @business.id,
          subscribed_at: Time.now.utc,
          subscription_id: @subscription.id
        }
        seats.push(new_seat)
      end

      Seat.create(seats)
    end
  end
end
