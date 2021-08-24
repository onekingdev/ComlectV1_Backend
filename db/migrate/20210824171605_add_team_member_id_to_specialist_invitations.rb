class AddTeamMemberIdToSpecialistInvitations < ActiveRecord::Migration[6.0]
  def change
    add_reference :specialist_invitations, :team_member
  end
end
