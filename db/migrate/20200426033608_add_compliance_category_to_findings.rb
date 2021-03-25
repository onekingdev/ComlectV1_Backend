# frozen_string_literal: true

class AddComplianceCategoryToFindings < ActiveRecord::Migration[6.0]
  def change
    add_column :findings, :compliance_category, :integer, default: nil
  end
end
