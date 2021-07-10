# frozen_string_literal: true

class AddTeamRefToSpecialist < ActiveRecord::Migration[6.0]
  def change
    add_reference :specialists, :specialist_team
  end
end
