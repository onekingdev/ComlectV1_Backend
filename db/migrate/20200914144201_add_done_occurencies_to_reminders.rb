# frozen_string_literal: true

class AddDoneOccurenciesToReminders < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :done_occurencies, :text, default: nil
  end
end
