# frozen_string_literal: true

class CreateCompliancePolicyRisks < ActiveRecord::Migration[6.0]
  def change
    create_table :compliance_policy_risks do |t|
      t.string :name
      t.integer :level
      t.text :description
      t.integer :compliance_policy_id
      t.string :status
      t.integer :business_id

      t.timestamps
    end
  end
end
