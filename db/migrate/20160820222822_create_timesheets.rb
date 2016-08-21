# frozen_string_literal: true
class CreateTimesheets < ActiveRecord::Migration
  def change
    create_table :timesheets do |t|
      t.references :project, index: true
      t.string :status, null: false, default: 'pending'

      t.timestamps null: false
    end
    add_index :timesheets, :status
  end
end
