# frozen_string_literal: true

class RenameInactiveForMonthInUsersToInactiveForPeriod < ActiveRecord::Migration
  def change
    rename_column :users, :inactive_for_month, :inactive_for_period
  end
end
