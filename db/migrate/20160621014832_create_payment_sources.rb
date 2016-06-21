# frozen_string_literal: true
class CreatePaymentSources < ActiveRecord::Migration
  def change
    create_table :payment_sources do |t|
      t.references :payment_profile, index: true
      t.string :stripe_card_id, null: false
      t.string :brand, null: false
      t.integer :exp_month, null: false
      t.integer :exp_year, null: false
      t.string :last4, null: false
      t.boolean :primary, null: false, default: false

      t.timestamps null: false
    end
    add_index :payment_sources, :stripe_card_id, unique: true
  end
end
