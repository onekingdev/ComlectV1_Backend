# frozen_string_literal: true

class AddBusinessToCompliancePolicies < ActiveRecord::Migration
  def change
    add_column :compliance_policies, :business_id, :integer, default: nil
  end
end
