# frozen_string_literal: true

class ChangeTransactionsStatusDefault < ActiveRecord::Migration
  def change
    change_column_default :transactions, :status, 'pending'
    reversible do |dir|
      dir.up do
        Transaction.where(status: nil).update_all status: 'pending'
      end
    end
  end
end
