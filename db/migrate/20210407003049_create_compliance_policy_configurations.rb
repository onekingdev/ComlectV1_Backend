# frozen_string_literal: true

class CreateCompliancePolicyConfigurations < ActiveRecord::Migration[6.0]
  def change
    create_table :compliance_policy_configurations do |t|
      t.integer :business_id
      t.jsonb :logo_data
      t.boolean :address
      t.boolean :phone
      t.boolean :email
      t.boolean :disclosure
      t.text :body

      t.timestamps
    end
  end
end
