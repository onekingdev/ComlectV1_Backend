class AddUntouchedToCompliancePolicies < ActiveRecord::Migration[6.0]
  def change
    add_column :compliance_policies, :untouched, :boolean, default: true
  end
end
