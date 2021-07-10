# frozen_string_literal: true

class CreateCompliancePolicies < ActiveRecord::Migration[6.0]
  def change
    create_table :compliance_policies do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
