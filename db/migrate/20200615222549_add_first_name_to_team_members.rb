# frozen_string_literal: true

class AddFirstNameToTeamMembers < ActiveRecord::Migration
  def change
    add_column :team_members, :first_name, :string
    add_column :team_members, :last_name, :string
  end
end
