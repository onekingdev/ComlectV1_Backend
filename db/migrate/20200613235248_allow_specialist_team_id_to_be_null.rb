# frozen_string_literal: true

class AllowSpecialistTeamIdToBeNull < ActiveRecord::Migration[6.0]
  def change
    change_column :specialist_invitations, :specialist_team_id, :integer, null: true
  end
end
