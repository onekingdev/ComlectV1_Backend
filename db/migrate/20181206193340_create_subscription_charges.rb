class CreateSubscriptionCharges < ActiveRecord::Migration
  def change
    create_table :subscription_charges do |t|
      t.string :stripe_charge_id
      t.integer :status
      t.string :plan
      t.timestamps null: false
    end
  end
end
