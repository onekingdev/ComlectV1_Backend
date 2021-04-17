# frozen_string_literal: true

class AddArchivedToCompliancePolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :compliance_policies, :archived, :boolean, default: false
  end
end
