# frozen_string_literal: true

class ConvertSpecialistTeamIdToTeamId < ActiveRecord::Migration[6.0]
  def change
    rename_column :specialists, :specialist_team_id, :team_id
  end
end
