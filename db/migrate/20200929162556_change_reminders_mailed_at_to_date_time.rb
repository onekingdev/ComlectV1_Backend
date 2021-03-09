# frozen_string_literal: true

class ChangeRemindersMailedAtToDateTime < ActiveRecord::Migration[6.0]
  def change
    change_column :businesses, :reminders_mailed_at, :datetime
    change_column :specialists, :reminders_mailed_at, :datetime
  end
end
