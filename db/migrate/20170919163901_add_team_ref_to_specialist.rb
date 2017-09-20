# frozen_string_literal: true

class AddTeamRefToSpecialist < ActiveRecord::Migration
  def change
    add_reference :specialists, :specialist_team
  end
end
