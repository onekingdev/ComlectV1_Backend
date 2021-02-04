# frozen_string_literal: true

class AddDescriptionToReminders < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :description, :text, default: ''
  end
end
