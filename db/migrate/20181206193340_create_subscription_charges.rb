# frozen_string_literal: true

class CreateSubscriptionCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :subscription_charges do |t|
      t.string :stripe_charge_id
      t.integer :status
      t.string :plan
      t.timestamps null: false
    end
  end
end
