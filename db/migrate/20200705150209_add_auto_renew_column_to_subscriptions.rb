# frozen_string_literal: true

class AddAutoRenewColumnToSubscriptions < ActiveRecord::Migration[6.0]
  def change
    add_column :subscriptions, :auto_renew, :boolean, default: false
    add_column :forum_subscriptions, :auto_renew, :boolean, default: false
    add_column :subscriptions, :status, :integer, default: 0
  end
end
