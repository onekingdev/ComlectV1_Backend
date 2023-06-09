# frozen_string_literal: true

class ChangeCofToInteger < ActiveRecord::Migration[6.0]
  def change
    remove_column :annual_reports, :cof_bits
    add_column :annual_reports, :cof_bits, :integer, default: nil
  end
end
