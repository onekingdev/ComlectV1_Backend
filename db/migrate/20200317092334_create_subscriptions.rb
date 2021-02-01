# frozen_string_literal: true

class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.bigint :business_id
      t.string :stripe_subscription_id
      t.string :stripe_invoice_item_id
      t.integer :plan, default: 0

      t.timestamps null: false
    end
  end
end
