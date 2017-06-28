# frozen_string_literal: true

class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.references :stripe_account, index: true
      t.string :stripe_id
      t.boolean :primary, null: false, default: false
      t.string :country
      t.string :currency
      t.string :routing_number
      t.string :account_number

      t.timestamps null: false
    end
  end
end
