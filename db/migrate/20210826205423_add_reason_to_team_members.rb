class AddReasonToTeamMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :reason, :string
  end
end
