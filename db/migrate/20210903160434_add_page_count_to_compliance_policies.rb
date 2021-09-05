class AddPageCountToCompliancePolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :compliance_policies, :page_count, :integer, default: nil
  end
end
