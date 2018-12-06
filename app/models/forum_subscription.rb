# frozen_string_literal: true

# Schema
# t.belongs_to :business, index: true
# t.integer :billing_type, default: 0
# t.integer :level, default: 0
# t.boolean :suspended, default: false
# t.datetime :expiration
# t.timestamps null: false

class ForumSubscription < ActiveRecord::Base
  belongs_to :business

  enum billing_type: %i[annual monthly]
  enum level: %i[free basic pro]

  after_create :create_subscription

  def return_plan_id
    "#{Rails.env.production? ? 'production' : 'staging'}_#{level}_#{billing_type}"
  end

  def create_subscription
    # sub = Stripe::Subscription.create(
    #   customer: business.payment_profile.stripe_customer_id,
    #   items: [{ plan: return_plan_id }]
    # )
    # rescue StandardError => e
    #   puts e
    # end
  end
end
