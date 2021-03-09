# frozen_string_literal: true

class AddRemindersMailedToBusinessAndSpecialist < ActiveRecord::Migration
  def change
    add_column :businesses, :reminders_mailed_at, :date, default: nil
    add_column :specialists, :reminders_mailed_at, :date, default: nil
  end
end
