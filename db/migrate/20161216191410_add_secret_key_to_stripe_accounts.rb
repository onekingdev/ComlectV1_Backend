# frozen_string_literal: true

class AddSecretKeyToStripeAccounts < ActiveRecord::Migration
  def change
    add_column :stripe_accounts, :secret_key, :string
    add_column :stripe_accounts, :publishable_key, :string
  end
end
