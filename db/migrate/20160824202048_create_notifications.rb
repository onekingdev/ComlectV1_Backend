# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user, index: true
      t.string :message
      t.string :path
      t.datetime :read_at

      t.timestamps null: false
    end
    add_index :notifications, :read_at
  end
end
