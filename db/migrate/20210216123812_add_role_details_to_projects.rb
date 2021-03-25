# frozen_string_literal: true

class AddRoleDetailsToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :role_details, :text, default: ''
  end
end
