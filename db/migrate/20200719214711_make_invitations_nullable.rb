# frozen_string_literal: true

class MakeInvitationsNullable < ActiveRecord::Migration[6.0]
  def change
    change_column :specialist_invitations, :last_name, :string, null: true
  end
end
