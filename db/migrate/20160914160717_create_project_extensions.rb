# frozen_string_literal: true
class CreateProjectExtensions < ActiveRecord::Migration
  def change
    create_table :project_extensions do |t|
      t.references :project, index: true
      t.date :new_end_date
      t.datetime :expires_at
      t.string :status

      t.timestamps null: false
    end
    add_index :project_extensions, :status
    add_index :project_extensions, :expires_at
  end
end
