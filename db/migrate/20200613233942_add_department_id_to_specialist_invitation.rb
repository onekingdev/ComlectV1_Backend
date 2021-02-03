# frozen_string_literal: true

class AddDepartmentIdToSpecialistInvitation < ActiveRecord::Migration[6.0]
  def change
    add_column :specialist_invitations, :team_id, :integer

    add_index :specialist_invitations, :team_id
  end
end
