# frozen_string_literal: true

class RemoveExpirationFromForumSubscription < ActiveRecord::Migration[6.0]
  def change
    remove_column :forum_subscriptions, :expiration
  end
end
