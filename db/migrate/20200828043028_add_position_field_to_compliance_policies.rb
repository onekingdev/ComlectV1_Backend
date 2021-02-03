# frozen_string_literal: true

class AddPositionFieldToCompliancePolicies < ActiveRecord::Migration
  def change
    add_column :compliance_policies, :position, :integer
  end
end
