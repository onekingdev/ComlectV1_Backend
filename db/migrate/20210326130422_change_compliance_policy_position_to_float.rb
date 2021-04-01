# frozen_string_literal: true

class ChangeCompliancePolicyPositionToFloat < ActiveRecord::Migration[6.0]
  def change
    change_column :compliance_policies, :position, :float
  end
end
