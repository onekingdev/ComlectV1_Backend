# frozen_string_literal: true

class ReplaceBusinessChangesWithField < ActiveRecord::Migration[6.0]
  def change
    drop_table :business_changes
    add_column :annual_reports, :material_business_changes, :text, default: ''
  end
end
