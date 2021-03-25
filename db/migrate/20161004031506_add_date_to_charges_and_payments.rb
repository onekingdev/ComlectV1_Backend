# frozen_string_literal: true

class AddDateToChargesAndPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :charges, :date, :datetime, null: false
    add_column :payments, :date, :datetime, null: false
  end
end
