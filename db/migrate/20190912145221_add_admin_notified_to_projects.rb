# frozen_string_literal: true

class AddAdminNotifiedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :admin_notified, :boolean, default: false
  end
end
