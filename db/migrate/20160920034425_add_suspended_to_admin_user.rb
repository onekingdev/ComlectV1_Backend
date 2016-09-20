# frozen_string_literal: true
class AddSuspendedToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :suspended, :boolean, default: false
  end
end
