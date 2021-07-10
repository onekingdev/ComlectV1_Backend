# frozen_string_literal: true

class IndexNotificationsPath < ActiveRecord::Migration[6.0]
  def change
    add_index :notifications, :path
  end
end
