# frozen_string_literal: true

class AddRecurringToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :repeats, :string, default: nil # daily weekly monthly yearly
    add_column :reminders, :end_by, :date, default: nil
    add_column :reminders, :repeat_every, :integer, default: nil # number of day/weeks/months/month of a year (if yearly)
    add_column :reminders, :repeat_on, :integer, default: nil # on day/weekday
    add_column :reminders, :on_type, :string, default: nil # weekday(nil),day,weekday[1st..4th]
    add_column :reminders, :skip_dates, :text, default: ''
  end
end
