# frozen_string_literal: true

class AddCreditToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :business_credit_in_cents, :integer, default: 0
    add_column :transactions, :specialist_credit_in_cents, :integer, default: 0
  end
end
