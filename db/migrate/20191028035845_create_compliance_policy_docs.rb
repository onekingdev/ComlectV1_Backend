# frozen_string_literal: true

class CreateCompliancePolicyDocs < ActiveRecord::Migration
  def change
    create_table :compliance_policy_docs do |t|
      t.timestamps null: false
    end
  end
end
