# frozen_string_literal: true

class AddCompliancePoliciesSpawnedToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :compliance_policies_spawned, :boolean, default: false
  end
end
