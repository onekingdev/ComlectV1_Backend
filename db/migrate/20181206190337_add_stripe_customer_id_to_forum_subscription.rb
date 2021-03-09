# frozen_string_literal: true

class AddStripeCustomerIdToForumSubscription < ActiveRecord::Migration[6.0]
  def change
    add_column :forum_subscriptions, :stripe_customer_id, :string
  end
end
