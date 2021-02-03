# frozen_string_literal: true

class AddTitleToTeamMembers < ActiveRecord::Migration
  def change
    add_column :team_members, :title, :string, default: nil
  end
end
