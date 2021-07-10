# frozen_string_literal: true

class CreatePaymentProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_profiles do |t|
      t.references :business, index: true
      t.string :stripe_customer_id

      t.timestamps null: false
    end
  end
end
