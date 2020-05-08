# frozen_string_literal: true

class AddLastUploadedToCompliancePolicy < ActiveRecord::Migration
  def change
    add_column :compliance_policies, :last_uploaded, :datetime, default: nil
  end
end
