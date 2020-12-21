# frozen_string_literal: true

class CreateProjectIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :project_issues do |t|
      t.references :project, index: true
      t.references :user, index: true
      t.text :issue
      t.text :desired_resolution

      t.timestamps null: false
    end
  end
end
