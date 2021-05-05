# frozen_string_literal: true

class AddLinkableToReminders < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :linkable_id, :integer, default: nil
    add_column :reminders, :linkable_type, :string, default: nil
  end
end
