# frozen_string_literal: true
class AddAchFieldsToPaymentSources < ActiveRecord::Migration
  def change
    change_table :payment_sources do |t|
      t.string :type
      t.string :country
      t.string :currency
      t.string :account_holder_name
      t.string :account_holder_type
      t.boolean :validated, null: false, default: false
    end
    rename_column :payment_sources, :stripe_card_id, :stripe_id
    add_index :payment_sources, :type
  end
end
