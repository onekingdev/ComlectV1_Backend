# frozen_string_literal: true

class AddSuperAdminToAdminUser < ActiveRecord::Migration
  def change
    add_column :admin_users, :super_admin, :boolean, default: false
    AdminUser.update_all(super_admin: true)
  end
end
