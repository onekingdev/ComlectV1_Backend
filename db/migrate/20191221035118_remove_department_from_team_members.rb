# frozen_string_literal: true

class RemoveDepartmentFromTeamMembers < ActiveRecord::Migration[6.0]
  def change
    remove_column :team_members, :department
  end
end
