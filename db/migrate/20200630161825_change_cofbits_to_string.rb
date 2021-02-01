# frozen_string_literal: true

class ChangeCofbitsToString < ActiveRecord::Migration[6.0]
  def change
    change_column :annual_reports, :cof_bits, :string
  end
end
