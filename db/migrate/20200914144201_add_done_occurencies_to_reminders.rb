# frozen_string_literal: true

class AddDoneOccurenciesToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :done_occurencies, :text, default: nil
  end
end
