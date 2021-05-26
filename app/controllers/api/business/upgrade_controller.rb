# frozen_string_literal: true

class Api::Business::UpgradeController < ApiController
  before_action :require_business!

  def subscribe
    respond_with(errors: { plan: 'Wrong plan name' }) && return unless Subscription.plans.key?(turnkey_params[:plan]&.parameterize)
    respond_with(errors: { subscribe: 'No payment source' }) && return unless payment_source || turnkey_params[:plan] == 'free'
    active_subscriptions = current_business.subscriptions.where(status: 'active').where.not(plan: %w[seats_monthly seats_annual])

    processed_subs = []

    if turnkey_params[:plan] != 'free'
      begin
        seat_sub = %w[seats_monthly seats_annual].include?(turnkey_params[:plan])
        seat_count = turnkey_params.to_h.key?(:cnt) ? turnkey_params[:cnt].to_i : 1
        total_seats = current_business&.seats&.count

        cancel_subscriptions(active_subscriptions) if active_subscriptions.count.positive? && !seat_sub

        (1..seat_count).to_a.each do |i|
          db_subscription = Subscription.create(
            plan: turnkey_params[:plan]&.parameterize,
            business_id: current_business.id,
            kind_of: (seat_sub ? :seats : :ccc),
            title: (seat_sub ? "Seat ##{total_seats + i}" : 'Compliance Command Center'),
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
              billing_period_ends: sub.cancel_at
            )
            current_business.update(onboarding_passed: true)
          end
          processed_subs.push(db_subscription)
        end
      rescue Stripe::StripeError => e
        render json: { error: e.message, processed: serialize_subs(processed_subs) }, status: :unprocessable_entity && return
      end
    else
      current_business.update(onboarding_passed: true)
    end
    render json: { message: 'subscribed', processed: serialize_subs(processed_subs) }, status: :created
  end

  private

  def serialize_subs(subs)
    subs.map(&proc { |psub| SubscriptionSerializer.new(psub).serializable_hash })
  end

  def cancel_subscriptions(active_subscriptions)
    active_subscriptions.each do |active_subscription|
      Stripe::CancelSubscription.call(active_subscription.stripe_subscription_id)
      active_subscription.update(status: Subscription.statuses['canceled'])
    end
  end

  def turnkey_params
    params.permit(:plan, :cnt, :payment_source_id)
  end

  def payment_source
    @payment_source ||= current_business.payment_profile&.payment_sources&.find(params[:payment_source_id])
  end

  def stripe_customer
    current_business.payment_profile.stripe_customer
  end
end
