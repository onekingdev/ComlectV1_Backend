# frozen_string_literal: true

class CreateCharges < ActiveRecord::Migration[6.0]
  def change
    create_table :charges do |t|
      t.references :project, index: true, null: false
      t.references :payment_source, index: true
      t.integer :amount_in_cents, null: false
      t.datetime :process_after, null: false
      t.string :status, null: false, default: 'scheduled'
      t.string :status_detail
      t.string :description

      t.timestamps null: false
    end
    add_index :charges, :process_after
    add_index :charges, :status
  end
end
