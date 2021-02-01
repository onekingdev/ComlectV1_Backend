# frozen_string_literal: true

class RemoveDepartmentFromTeamMembers < ActiveRecord::Migration
  def change
    remove_column :team_members, :department
  end
end
