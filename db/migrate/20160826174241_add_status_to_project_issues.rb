# frozen_string_literal: true

class AddStatusToProjectIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :project_issues, :status, :string, null: false, default: 'open'
    add_index :project_issues, :status
  end
end
