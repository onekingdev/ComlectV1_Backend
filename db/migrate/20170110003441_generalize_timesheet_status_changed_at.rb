# frozen_string_literal: true

class GeneralizeTimesheetStatusChangedAt < ActiveRecord::Migration
  def change
    rename_column :timesheets, :approved_at, :status_changed_at
  end
end
