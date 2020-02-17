# frozen_string_literal: true

class AddDoneAtToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :done_at, :datetime, default: nil
  end
end
