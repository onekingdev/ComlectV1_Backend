class AddEditedAtToCompliancePolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :compliance_policies, :edited_at, :datetime, default: nil
  end
end
