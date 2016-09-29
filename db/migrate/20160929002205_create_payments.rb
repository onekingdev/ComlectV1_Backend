# frozen_string_literal: true
class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :project, index: true, null: false
      t.integer :amount_in_cents, null: false
      t.datetime :process_after, null: false
      t.string :status, null: false, default: 'scheduled'
      t.string :status_detail
      t.string :description

      t.timestamps null: false
    end
    add_index :payments, :process_after
    add_index :payments, :status
  end
end
