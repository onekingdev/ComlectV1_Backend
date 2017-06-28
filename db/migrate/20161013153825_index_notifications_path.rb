# frozen_string_literal: true

class IndexNotificationsPath < ActiveRecord::Migration
  def change
    add_index :notifications, :path
  end
end
