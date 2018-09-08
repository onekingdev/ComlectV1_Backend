# frozen_string_literal: true

class AddAccountsToTurnkeys < ActiveRecord::Migration
  def change
    add_column :turnkey_solutions, :accounts_enabled, :boolean, default: false
  end
end
