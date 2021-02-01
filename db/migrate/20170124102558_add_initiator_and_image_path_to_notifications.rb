# frozen_string_literal: true

class AddInitiatorAndImagePathToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :initiator, :string
    add_column :notifications, :img_path, :string
  end
end
