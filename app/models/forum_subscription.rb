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
# t.datetime :renewal_date

class ForumSubscription < ActiveRecord::Base
  belongs_to :business
  has_many :subscription_charges

  enum billing_type: %i[annual monthly]
  enum level: %i[free basic pro]

  after_create :create_subscription
  before_destroy :cancel

  def return_plan_id
    environment = ENV['STRIPE_PUBLISHABLE_KEY'].start_with?('pk_test') ? 'staging' : 'production'
    environment = 'staging' if Rails.env.development?
    "#{environment}_#{level}_#{billing_type}"
  end

  def create_subscription
    update(stripe_customer_id: business.payment_profile.stripe_customer_id)
    trial_date = Date.new(2019, 5, 31).to_time.to_i
    trial_end_date = trial_date > Time.now.getutc.to_i ? trial_date : nil
    begin
      Stripe::Subscription.create(
        customer: stripe_customer_id,
        items: [{ plan: return_plan_id }],
        trial_end: trial_end_date
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
    update(cancelled: false)
  end

  def cancel
    # will need to use a webhook to set a cancellation date for front end messaging
    subscription = Stripe::Subscription.retrieve(stripe_subscription_id)
    subscription.cancel_at_period_end = true
    subscription.save
    update(cancelled: true)
  end

  def renewal_date_hr
    renewal_date.strftime('%m/%d/%y')
  end
end
