# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :stripe_id
      t.string :type
      t.integer :amount_in_cents, null: false
      t.datetime :processed_at
      t.string :status
      t.references :charge_source, index: true
      t.references :payment_target, index: true

      t.timestamps null: false
    end
    add_index :transactions, :type
    add_index :transactions, :processed_at
    add_index :transactions, :status

    reversible do |dir|
      dir.up do
        remove_column :charges, :payment_source_id, :integer
      end

      dir.down do
        add_reference :charges, :payment_source, index: true
      end
    end
  end
end
