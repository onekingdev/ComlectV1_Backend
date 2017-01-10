# frozen_string_literal: true
class AddFirstSubmittedAtToTimesheets < ActiveRecord::Migration
  def change
    add_column :timesheets, :first_submitted_at, :datetime
    add_index :timesheets, :first_submitted_at, order: :asc
  end
end
