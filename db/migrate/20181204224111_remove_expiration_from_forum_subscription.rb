# frozen_string_literal: true

class RemoveExpirationFromForumSubscription < ActiveRecord::Migration
  def change
    remove_column :forum_subscriptions, :expiration
  end
end
