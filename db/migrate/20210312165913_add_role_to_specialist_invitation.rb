# frozen_string_literal: true

class AddRoleToSpecialistInvitation < ActiveRecord::Migration[6.0]
  def change
    add_column :specialist_invitations, :role, :integer, default: 0
  end
end
