class RemoveExpirationFromForumSubscription < ActiveRecord::Migration
  def change
    remove_column :forum_subscriptions, :expiration
  end
end
