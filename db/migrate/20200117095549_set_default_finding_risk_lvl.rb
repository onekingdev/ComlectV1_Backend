# frozen_string_literal: true

class SetDefaultFindingRiskLvl < ActiveRecord::Migration[6.0]
  def change
    change_column :findings, :risk_lvl, :integer, default: 3
  end
end
