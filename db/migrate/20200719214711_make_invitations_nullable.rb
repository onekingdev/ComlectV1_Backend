# frozen_string_literal: true

class MakeInvitationsNullable < ActiveRecord::Migration
  def change
    change_column :specialist_invitations, :last_name, :string, null: true
  end
end
