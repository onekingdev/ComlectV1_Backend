# frozen_string_literal: true

class AddFeeInCentsToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :fee_in_cents, :integer
    add_index :transactions, :fee_in_cents
  end
end
