# frozen_string_literal: true

class AddDoneAtToReminders < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :done_at, :datetime, default: nil
  end
end
