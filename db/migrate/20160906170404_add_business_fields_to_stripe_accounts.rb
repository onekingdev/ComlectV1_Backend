# frozen_string_literal: true

class AddBusinessFieldsToStripeAccounts < ActiveRecord::Migration[6.0]
  def change
    change_table :stripe_accounts do |t|
      t.string :account_type, null: false, default: 'individual'
      t.string :stripe_id
      t.string :business_name
      t.string :business_tax_id
    end
  end
end
