# frozen_string_literal: true

class AddAmountToSubscriptionCharge < ActiveRecord::Migration
  def change
    add_column :subscription_charges, :amount, :integer
  end
end
