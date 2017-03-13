# frozen_string_literal: true
class AddPrimaryToStripeAccounts < ActiveRecord::Migration
  def change
    add_column :stripe_accounts, :primary, :boolean, null: false, default: false
    reversible do |dir|
      dir.up do
        StripeAccount.update_all primary: true
      end
    end
  end
end
