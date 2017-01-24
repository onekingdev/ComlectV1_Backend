# frozen_string_literal: true
class AddSuspendedToUsers < ActiveRecord::Migration
  def change
    rename_column :users, :deleted, :suspended
    rename_column :users, :deleted_at, :suspended_at
    add_column :users, :deleted, :boolean, null: false, default: false
    add_column :users, :deleted_at, :datetime
  end
end
