# frozen_string_literal: true

class AddEndDateToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :end_date, :date, default: nil
  end
end
