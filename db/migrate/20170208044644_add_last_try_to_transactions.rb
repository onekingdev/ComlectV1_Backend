# frozen_string_literal: true
class AddLastTryToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :last_try_at, :datetime
    add_index :transactions, :last_try_at
    reversible do |dir|
      dir.up do
        Transaction.update_all 'last_try_at = CASE WHEN processed_at IS NOT NULL THEN processed_at ELSE updated_at END'
      end
    end
  end
end
