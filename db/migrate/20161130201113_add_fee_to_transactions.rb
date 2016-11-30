# frozen_string_literal: true
class AddFeeToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :fee_in_cents, :integer, null: false, default: 0
  end
end
