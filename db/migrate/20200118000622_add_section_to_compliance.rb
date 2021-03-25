# frozen_string_literal: true

class AddSectionToCompliance < ActiveRecord::Migration
  def change
    add_column :compliance_policies, :section, :string, default: nil
  end
end
