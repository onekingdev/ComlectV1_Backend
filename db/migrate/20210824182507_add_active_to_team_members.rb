class AddActiveToTeamMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :active, :boolean, default: true
  end
end
