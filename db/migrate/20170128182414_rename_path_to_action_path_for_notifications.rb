# frozen_string_literal: true
class RenamePathToActionPathForNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :path, :action_path
  end
end
