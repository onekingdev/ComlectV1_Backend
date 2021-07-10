# frozen_string_literal: true

class AddAccountsToTurnkeys < ActiveRecord::Migration[6.0]
  def change
    add_column :turnkey_solutions, :accounts_enabled, :boolean, default: false
  end
end
