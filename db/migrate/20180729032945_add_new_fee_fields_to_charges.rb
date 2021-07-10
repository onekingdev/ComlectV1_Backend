# frozen_string_literal: true

class AddNewFeeFieldsToCharges < ActiveRecord::Migration[6.0]
  def change
    add_column :charges, :business_fee_in_cents, :integer
    add_column :charges, :specialist_fee_in_cents, :integer
  end
end
