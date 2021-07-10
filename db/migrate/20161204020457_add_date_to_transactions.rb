# frozen_string_literal: true

class AddDateToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :date, :datetime
    add_index :transactions, :date
    reversible do |dir|
      dir.up do
        execute 'UPDATE transactions SET date = created_at'
      end
    end
  end
end
