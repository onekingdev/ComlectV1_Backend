# frozen_string_literal: true

class AddFeeInCentsToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :fee_in_cents, :integer
    add_index :transactions, :fee_in_cents
    reversible do |dir|
      dir.up do
        # Set previous transactions to the old values
        Transaction::BusinessCharge.update_all 'fee_in_cents = amount_in_cents * 0.15'
        Transaction::SpecialistPayment.update_all 'fee_in_cents = 0'
      end
    end
  end
end
