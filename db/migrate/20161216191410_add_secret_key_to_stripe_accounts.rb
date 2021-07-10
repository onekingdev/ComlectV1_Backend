# frozen_string_literal: true

class AddSecretKeyToStripeAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_accounts, :secret_key, :string
    add_column :stripe_accounts, :publishable_key, :string
  end
end
