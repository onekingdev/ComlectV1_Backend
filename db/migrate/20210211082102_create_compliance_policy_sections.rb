# frozen_string_literal: true

class CreateCompliancePolicySections < ActiveRecord::Migration[6.0]
  def change
    create_table :compliance_policy_sections do |t|
      t.integer :compliance_policy_id
      t.integer :parent_id
      t.string :name
      t.text :description
      t.integer :order

      t.timestamps
    end
  end
end
