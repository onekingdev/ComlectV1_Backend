class AddRoleToTeamMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :role, :string
  end
end
