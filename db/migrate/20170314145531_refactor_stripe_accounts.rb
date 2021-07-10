# frozen_string_literal: true

class RefactorStripeAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_column :specialists, :stripe_account_id, :string
    remove_column :specialists, :stripe_secret_key, :string
    remove_column :specialists, :stripe_publishable_key, :string

    add_column :stripe_accounts, :secret_key, :string
    add_column :stripe_accounts, :publishable_key, :string

    remove_column :stripe_accounts, :primary, :boolean, null: false, default: false
    remove_column :stripe_accounts, :account_currency, :string
    remove_column :stripe_accounts, :account_routing_number, :string
    remove_column :stripe_accounts, :account_number, :string
  end
end
