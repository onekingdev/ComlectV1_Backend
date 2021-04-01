# frozen_string_literal: true

class ChangeCompliancePolicyRisks < ActiveRecord::Migration[6.0]
  def change
    rename_table :compliance_policy_risks, :risks
    remove_column :risks, :status
    remove_column :risks, :compliance_policy_id
    remove_column :risks, :description
    rename_column :risks, :level, :impact
    add_column :risks, :likelihood, :integer, default: nil
  end
end
