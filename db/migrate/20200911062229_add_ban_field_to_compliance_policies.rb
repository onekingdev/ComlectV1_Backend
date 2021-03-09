# frozen_string_literal: true

class AddBanFieldToCompliancePolicies < ActiveRecord::Migration
  def change
    add_column :compliance_policies, :ban, :boolean, default: false
  end
end
