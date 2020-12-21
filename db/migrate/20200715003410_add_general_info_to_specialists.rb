# frozen_string_literal: true

class AddGeneralInfoToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :annual_revenue_goal, :decimal, default: nil
    add_column :specialists, :risk_tolerance, :string, default: nil
  end
end
