# frozen_string_literal: true
class MoveFeesToChargesTable < ActiveRecord::Migration
  def change
    add_column :charges, :fee_in_cents, :integer
    add_column :charges, :total_with_fee_in_cents, :integer
    add_column :charges, :running_balance_in_cents, :integer
    add_column :charges, :specialist_amount_in_cents, :integer, default: 0, null: false
    remove_column :transactions, :fee_in_cents, :integer
    reversible do |dir|
      dir.up do
        Charge.update_all 'fee_in_cents = amount_in_cents * 0.10'
        Charge.update_all 'total_with_fee_in_cents = amount_in_cents + fee_in_cents'
      end
    end
  end
end
