# frozen_string_literal: true

class AddDateToChargesAndPayments < ActiveRecord::Migration
  def change
    add_column :charges, :date, :datetime, null: false
    add_column :payments, :date, :datetime, null: false
  end
end
