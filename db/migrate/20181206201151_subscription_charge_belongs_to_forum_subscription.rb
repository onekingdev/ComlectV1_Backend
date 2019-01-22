# frozen_string_literal: true

class SubscriptionChargeBelongsToForumSubscription < ActiveRecord::Migration
  def change
    add_reference :subscription_charges, :forum_subscription, index: true
  end
end
