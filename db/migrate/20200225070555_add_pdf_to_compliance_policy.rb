# frozen_string_literal: true

class AddPdfToCompliancePolicy < ActiveRecord::Migration
  def change
    add_column :compliance_policies, :pdf_data, :jsonb, default: nil
  end
end
