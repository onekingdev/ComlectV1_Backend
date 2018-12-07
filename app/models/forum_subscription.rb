# frozen_string_literal: true

# Schema
# t.belongs_to :business, index: true
# t.integer :billing_type, default: 0
# t.integer :level, default: 0
# t.boolean :suspended, default: false
# t.datetime :expiration
# t.timestamps null: false
# t.integer :fee
# t.string :stripe_customer_id

class ForumSubscription < ActiveRecord::Base
  belongs_to :business
  has_many :subscription_charges

  enum billing_type: %i[annual monthly]
  enum level: %i[free basic pro]

  after_create :create_subscription

  def return_plan_id
    "#{Rails.env.production? ? 'production' : 'staging'}_#{level}_#{billing_type}"
  end

  def create_subscription
    update(stripe_customer_id: business.payment_profile.stripe_customer_id)
    begin
      Stripe::Subscription.create(
        customer: stripe_customer_id,
        items: [{ plan: return_plan_id }]
      )
    rescue StandardError => e
      Rails.logger.info e
    end
  end

  def upgrade(_lvl, billing_type)
    billing_type.zero? ? annual! : monthly!
    pro!
    stripe_sub = Stripe::Subscription.retrieve(stripe_subscription_id)
    stripe_sub.items = [{
      id: stripe_sub.items.data[0].id,
      plan: return_plan_id
    }]
    stripe_sub.save
  end

  def cancel
    # will need to use a webhook to set a cancellation date for front end messaging
    subscription = Stripe::Subscription.retrieve(stripe_subscription_id)
    subscription.cancel_at_period_end = true
    subscription.save
  end
end
