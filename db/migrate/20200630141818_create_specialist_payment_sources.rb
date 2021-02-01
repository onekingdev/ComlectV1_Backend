# frozen_string_literal: true

class CreateSpecialistPaymentSources < ActiveRecord::Migration[6.0]
  def change
    create_table :specialist_payment_sources do |t|
      t.integer :specialist_id
      t.text :stripe_customer_id
      t.text :stripe_card_id
      t.text :brand
      t.integer :exp_month
      t.integer :exp_year
      t.text :last4
      t.boolean :primary, default: false

      t.timestamps
    end

    add_index :specialist_payment_sources, :specialist_id
  end
end
