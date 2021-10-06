class AddLast4ToStripeAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :stripe_accounts, :last4, :string
    add_column :stripe_accounts, :bank_name, :string
  end
end
