# frozen_string_literal: true

class AddApprovedAtToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :approved_at, :datetime
    add_index :timesheets, :approved_at
    reversible do |dir|
      dir.up do
        execute "UPDATE timesheets SET approved_at = updated_at WHERE status = '#{Timesheet.statuses[:approved]}'"
      end
    end
  end
end
