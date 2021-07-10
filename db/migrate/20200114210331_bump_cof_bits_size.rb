# frozen_string_literal: true

class BumpCofBitsSize < ActiveRecord::Migration[6.0]
  def change
    change_column :annual_reports, :cof_bits, :integer, limit: 8
  end
end
