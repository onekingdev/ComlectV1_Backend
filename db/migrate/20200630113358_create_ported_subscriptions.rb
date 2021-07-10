# frozen_string_literal: true

class CreatePortedSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :ported_subscriptions do |t|
      t.integer :specialist_id
      t.integer :period, default: 0
      t.datetime :subscribed_at
      t.datetime :billing_period_ends_at
      t.text :stripe_subscription_id

      t.timestamps
    end

    add_index :ported_subscriptions, :specialist_id
  end
end
