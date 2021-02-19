# frozen_string_literal: true

class AddCancelledToForumSubscriptions < ActiveRecord::Migration
  def change
    add_column :forum_subscriptions, :cancelled, :boolean, default: false
  end
end
