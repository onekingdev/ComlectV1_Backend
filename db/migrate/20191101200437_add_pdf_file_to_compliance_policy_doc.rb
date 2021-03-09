# frozen_string_literal: true

class AddPdfFileToCompliancePolicyDoc < ActiveRecord::Migration
  def change
    add_column :compliance_policy_docs, :pdf_data, :jsonb, default: nil
  end
end
