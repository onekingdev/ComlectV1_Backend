# frozen_string_literal: true

class AddClearManuallyToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :clear_manually, :boolean, default: false, null: false
    add_index :notifications, :clear_manually
  end
end
