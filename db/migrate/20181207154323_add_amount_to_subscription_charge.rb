# frozen_string_literal: true

class AddAmountToSubscriptionCharge < ActiveRecord::Migration[6.0]
  def change
    add_column :subscription_charges, :amount, :integer
  end
end
