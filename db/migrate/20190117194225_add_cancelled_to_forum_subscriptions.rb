# frozen_string_literal: true

class AddCancelledToForumSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :forum_subscriptions, :cancelled, :boolean, default: false
  end
end
