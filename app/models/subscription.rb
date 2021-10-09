# frozen_string_literal: true

class Subscription < ActiveRecord::Base
  SPECIALIST_PLANS = %w[specialist_pro free].freeze

  BUSINESS_PLANS = {
    1 => 'free',
    2 => 'team_tier_monthly',
    3 => 'team_tier_annual',
    4 => 'business_tier_monthly',
    5 => 'business_tier_annual'
  }.freeze

  PLAN_NAMES = {
    'free' => 'Free Plan',
    'seats_annual' => 'Seats Plan',
    'seats_monthly' => 'Seats Plan',
    'team_tier_annual' => 'Team Plan',
    'team_tier_monthly' => 'Team Plan',
    'business_tier_annual' => 'Business Plan',
    'business_tier_monthly' => 'Business Plan',
    'specialist_pro' => 'All Access Membership'
  }.freeze

  CURRENCIES = {
    'usd' => '$'
  }.freeze

  belongs_to :business, optional: true
  belongs_to :specialist, optional: true
  belongs_to :payment_source, optional: true

  belongs_to :specialist_payment_source,
    class_name: 'Specialist::PaymentSource',
    foreign_key: :specialist_payment_source_id, optional: true

  has_many :seats

  enum plan: %w[
    seats_monthly
    seats_annual
    team_tier_monthly
    team_tier_annual
    business_tier_monthly
    business_tier_annual
    specialist_pro
    free
  ]

  enum status: { active: 0, canceled: 1 }
  enum kind_of: { ccc: 0, forum: 1, seats: 2 }

  scope :base, -> { find_by(kind_of: 0) }
  scope :active, -> { where(status: 0) }

  class << self
    def get_plan_id(plan)
      case plan.to_s.downcase
      when 'seats_monthly' then ENV['STRIPE_SUB_SEATS_MONTHLY']
      when 'seats_annual' then ENV['STRIPE_SUB_SEATS_ANNUAL']
      when 'team_tier_monthly' then ENV['STRIPE_SUB_CCC_TEAM_TIER_MONTHLY']
      when 'team_tier_annual' then ENV['STRIPE_SUB_CCC_TEAM_TIER_ANNUAL']
      when 'business_tier_monthly' then ENV['STRIPE_SUB_CCC_BUSINESS_TIER_MONTHLY']
      when 'business_tier_annual' then ENV['STRIPE_SUB_CCC_BUSINESS_TIER_ANNUAL']
      when 'specialist_pro' then ENV['STRIPE_SUB_SPECIALIST_PRO']
      end
    end

    def subscribe(plan, customer_id, options = {})
      plan_id = get_plan_id(plan)
      return unless plan_id

      params = {
        customer: customer_id,
        items: [
          plan: plan_id,
          quantity: (options[:quantity] || 1)
        ]
      }

      if options[:coupon].present?
        params[:coupon] = options[:coupon]
      end

      if options[:period_ends].present?
        params[:cancel_at] = options[:period_ends]
        params[:proration_behavior] = :none
      end

      if options[:trial_end].present?
        params[:trial_end] = options[:trial_end]
      end

      if options[:cancel_at_period_end].present?
        params[:cancel_at_period_end] = options[:cancel_at_period_end]
      end

      Stripe::Subscription.create(params)
    end

    def create_invoice_item(customer_id)
      Stripe::InvoiceItem.create(
        amount: 50_000,
        currency: 'usd',
        customer: customer_id,
        description: 'On-boarding fee'
      )
    end
  end

  def price_interval
    "#{CURRENCIES[currency]}#{price}/#{interval}" if amount.present?
  end

  def price
    (amount / 100).to_i if amount.present?
  end

  def cancel!
    Stripe::CancelSubscription.call(stripe_subscription_id) unless free?
    update(status: 'canceled')
  rescue Stripe::StripeError => e
    # check if subscription was canceled before
    if e.message.include?('No such subscription')
      update(status: 'canceled')
    end
  end
end
