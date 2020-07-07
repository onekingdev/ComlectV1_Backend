# frozen_string_literal: true

class ConvertRemindersToPolymorphic < ActiveRecord::Migration
  def change
    rename_column :reminders, :business_id, :remindable_id
    add_column :reminders, :remindable_type, :string
    Reminder.update_all(remindable_type: 'Business')
  end
end
