# frozen_string_literal: true

class Subscription < ActiveRecord::Base
  belongs_to :business
  belongs_to :payment_source

  enum plan: %w[monthly annual]
  enum kind_of: { ccc: 0, forum: 1, seats: 2 }
  enum status: { active: 0, canceled: 1 }

  scope :base, -> { find_by(kind_of: 0) }
  scope :active, -> { find_by(status: 0) }

  # unsure stripe customer business.payment_profile.stripe_customer
  # create one-time payment via InvoiceItem to customer
  # create subscription

  def self.create_invoice_item(customer_id)
    Stripe::InvoiceItem.create(
      amount: 50_000,
      currency: 'usd',
      customer: customer_id,
      description: 'On-boarding fee'
    )
  end

  def self.subscribe(plan, customer_id, options = {}, coupon_id = nil)
    plan_id = get_plan_id(plan)
    return unless plan_id
    sub_attributes = {
      customer: customer_id,
      items: [
        plan: plan_id,
        quantity: (options[:quantity] || 1)
      ],
      coupon: coupon_id
    }
    if options[:period_ends].present?
      sub_attributes[:cancel_at] = options[:period_ends]
      sub_attributes[:proration_behavior] = :none
    end

    Stripe::Subscription.create(sub_attributes)
  end

  def self.get_plan_id(plan)
    case plan.to_s.downcase
    when 'monthly' then ENV['STRIPE_SUB_CCC_MONTHLY']
    when 'seats_monthly' then ENV['STRIPE_SUB_SEATS_MONTHLY']
    when 'annual' then ENV['STRIPE_SUB_CCC_ANNUAL']
    when 'seats_annual' then ENV['STRIPE_SUB_SEATS_ANNUAL']
    end
  end
end
