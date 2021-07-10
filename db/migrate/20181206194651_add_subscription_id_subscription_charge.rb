# frozen_string_literal: true

class AddSubscriptionIdSubscriptionCharge < ActiveRecord::Migration[6.0]
  def change
    add_column :subscription_charges, :stripe_subscription_id, :string
  end
end
