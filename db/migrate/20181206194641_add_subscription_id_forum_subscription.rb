# frozen_string_literal: true

class AddSubscriptionIdForumSubscription < ActiveRecord::Migration[6.0]
  def change
    add_column :forum_subscriptions, :stripe_subscription_id, :string
  end
end
