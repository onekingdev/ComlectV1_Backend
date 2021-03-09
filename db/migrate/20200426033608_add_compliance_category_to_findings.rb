# frozen_string_literal: true

class AddComplianceCategoryToFindings < ActiveRecord::Migration
  def change
    add_column :findings, :compliance_category, :integer, default: nil
  end
end
