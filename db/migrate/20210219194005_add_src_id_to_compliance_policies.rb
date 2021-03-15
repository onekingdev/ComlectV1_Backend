# frozen_string_literal: true

class AddSrcIdToCompliancePolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :compliance_policies, :src_id, :integer, default: nil
    rename_column :compliance_policies, :title, :name
    add_column :compliance_policies, :status, :string, default: 'draft'
  end
end
