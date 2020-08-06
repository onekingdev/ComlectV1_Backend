# frozen_string_literal: true

class Specialists::PortedBusinessesController < ApplicationController
  before_action :require_specialist!
  before_action :go_to_dashboard

  def index
    @active_subscription = current_specialist&.ported_subscriptions&.active&.first
    @payment_source = current_specialist&.default_payment_source
  end

  def buy; end

  def create
    @ported_business = current_specialist&.ported_businesses&.new(ported_params)
    if @ported_business.save
      Notification::Deliver.invite_business_to_join!(@ported_business)

      flash[:notice] = 'Company has been invited!'
    else
      flash[:error] = @ported_business.errors.full_messages.join(' and ')
    end
    redirect_to specialists_ported_businesses_path
  end

  def subscribe
    begin
      unless current_specialist&.default_payment_source
        raise "no payment source. Check <a href='#{specialists_settings_payment_path}'>payments settings</a>"
      end

      raise 'wrong plan' unless PortedSubscription.periods.key?(turnkey_params[:plan].to_s.strip.downcase)

      sub_options = {
        customer: current_specialist&.stripe_customer,
        items: [
          price: stripe_price_name(turnkey_params[:plan])
        ],
        cancel_at: (Time.now.utc + 1.year).to_i,
        proration_behavior: 'none'
      }
      if current_specialist&.ported_subscriptions&.active&.length&.positive?
        sub_options[:trial_end] = current_specialist&.ported_subscriptions&.active&.billing_period_ends_at&.to_i
      end

      sub = Stripe::Subscription.create(sub_options)
      current_specialist&.ported_subscriptions&.create!(
        period: PortedSubscription.periods[turnkey_params[:plan].to_s.strip.downcase],
        subscribed_at: Time.at(sub.created).utc,
        billing_period_ends_at: (Time.at(sub.created).utc + 1.year),
        stripe_subscription_id: sub.id,
        status: (sub.trial_end.nil? ? 1 : 0)
      )
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

  def new
    @ported_business = PortedBusiness.new
  end

  def delete
    current_specialist&.ported_businesses&.destroy(params[:id])

    redirect_to specialists_ported_businesses_path
  end

  private

  def turnkey_params
    params.require(:turnkey).permit(:plan)
  end

  def ported_params
    params.require(:ported_business).permit(:company, :email)
  end

  def stripe_price_name(plan)
    if plan.to_s.strip.casecmp('monthly').zero?
      ENV['STRIPE_TCS_MONTHLY']
    else
      ENV['STRIPE_TCS_ANNUAL']
    end
  end

  def go_to_dashboard
    redirect_to specialists_dashboard_path if employee?
  end
end
