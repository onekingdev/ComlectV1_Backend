# frozen_string_literal: true

class AddContractFieldsToProjectExtension < ActiveRecord::Migration[6.0]
  def change
    add_column :project_extensions, :new_starts_on, :date, default: nil
    add_column :project_extensions, :fixed_budget, :decimal, default: nil
    add_column :project_extensions, :hourly_rate, :decimal, default: nil
    add_column :project_extensions, :role_details, :text, default: nil
    add_column :project_extensions, :key_deliverables, :string, default: nil
  end
end
