class AddRoleToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :role, :integer, default: 0
  end
end
