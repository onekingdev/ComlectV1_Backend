# frozen_string_literal: true

class AddTitleToTeamMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :title, :string, default: nil
  end
end
