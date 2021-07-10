# frozen_string_literal: true

class CreateProjectEnds < ActiveRecord::Migration[6.0]
  def change
    create_table :project_ends do |t|
      t.references :project, index: true
      t.string :status
      t.datetime :expires_at

      t.timestamps null: false
    end
    add_index :project_ends, :status
    add_index :project_ends, :expires_at
  end
end
