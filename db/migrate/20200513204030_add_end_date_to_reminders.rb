# frozen_string_literal: true

class AddEndDateToReminders < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :end_date, :date, default: nil
  end
end
