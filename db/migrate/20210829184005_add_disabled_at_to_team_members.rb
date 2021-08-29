class AddDisabledAtToTeamMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :disabled_at, :datetime
    add_column :team_members, :description, :string
  end
end
