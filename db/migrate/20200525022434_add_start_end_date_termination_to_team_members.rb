# frozen_string_literal: true

class AddStartEndDateTerminationToTeamMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :team_members, :start_date, :date, default: nil
    add_column :team_members, :end_date, :date, default: nil
    add_column :team_members, :termination_reason, :text, default: nil
  end
end
