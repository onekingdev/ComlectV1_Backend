# frozen_string_literal: true

class CreateRisksCompliancePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :compliance_policies_risks do |t|
      t.references :risk, null: false, foreign_key: true, on_delete: :cascade
      t.references :compliance_policy, null: false, foreign_key: true, on_delete: :cascade
    end
  end
end
