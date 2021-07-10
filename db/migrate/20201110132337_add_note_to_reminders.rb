# frozen_string_literal: true

class AddNoteToReminders < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :note, :string, default: ''
  end
end
