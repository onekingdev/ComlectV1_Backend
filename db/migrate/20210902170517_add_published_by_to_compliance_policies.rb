class AddPublishedByToCompliancePolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :compliance_policies, :published_by, :string, default: nil
  end
end
