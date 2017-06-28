# frozen_string_literal: true

class AddLastSubmittedAtToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :last_submitted_at, :datetime
    reversible do |dir|
      dir.up do
        execute 'UPDATE timesheets SET last_submitted_at = first_submitted_at'
      end
    end
  end
end
