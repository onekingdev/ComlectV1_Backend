# frozen_string_literal: true

class AddSuspendedToAdminUser < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :suspended, :boolean, default: false
  end
end
