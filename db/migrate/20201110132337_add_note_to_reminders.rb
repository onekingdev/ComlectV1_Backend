# frozen_string_literal: true

class AddNoteToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :note, :string, default: ''
  end
end
