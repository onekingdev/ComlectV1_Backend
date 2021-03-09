# frozen_string_literal: true

class GeneralizeTimesheetStatusChangedAt < ActiveRecord::Migration[6.0]
  def change
    rename_column :timesheets, :approved_at, :status_changed_at
  end
end
