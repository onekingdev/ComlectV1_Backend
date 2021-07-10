# frozen_string_literal: true

class RenameInactiveForMonthInUsersToInactiveForPeriod < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :inactive_for_month, :inactive_for_period
  end
end
