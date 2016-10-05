# frozen_string_literal: true
class AssociateTransactions < ActiveRecord::Migration
  def change
    add_reference :charges, :transaction, index: true
    add_reference :payments, :transaction, index: true
    add_reference :transactions, :project, index: true
    change_column_null :transactions, :amount_in_cents, null: false
    add_reference :transactions, :parent_transaction, index: true
  end
end
