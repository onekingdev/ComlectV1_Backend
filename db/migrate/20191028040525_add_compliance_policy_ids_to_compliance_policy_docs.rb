# frozen_string_literal: true

class AddCompliancePolicyIdsToCompliancePolicyDocs < ActiveRecord::Migration[6.0]
  def change
    add_column :compliance_policy_docs, :compliance_policy_id, :integer, default: nil
  end
end
