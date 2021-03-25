# frozen_string_literal: true

class AddDocsCountToCompliancePolicies < ActiveRecord::Migration
  def change
    add_column :compliance_policies, :docs_count, :integer, default: 0
  end
end
