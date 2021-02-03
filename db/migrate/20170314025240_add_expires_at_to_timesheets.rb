# frozen_string_literal: true

class AddExpiresAtToTimesheets < ActiveRecord::Migration[6.0]
  def change
    add_column :timesheets, :expires_at, :datetime
    reversible do |dir|
      dir.up do
        Timesheet.submitted.each do |timesheet|
          timesheet.__send__ :set_expiration
          timesheet.update_column :expires_at, timesheet.expires_at
        end
      end
    end
  end
end
