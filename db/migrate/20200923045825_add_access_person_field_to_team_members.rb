# frozen_string_literal: true

class AddAccessPersonFieldToTeamMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :access_person, :boolean, default: false
    add_column :team_members, :business_member, :boolean, default: false
  end
end
