# frozen_string_literal: true

class ChangeCofbitsToString < ActiveRecord::Migration
  def change
    change_column :annual_reports, :cof_bits, :string
  end
end
