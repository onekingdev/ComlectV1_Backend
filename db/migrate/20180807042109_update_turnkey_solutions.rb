# frozen_string_literal: true

class UpdateTurnkeySolutions < ActiveRecord::Migration
  def change
    remove_column :turnkey_solutions, :project_location
    add_column :turnkey_solutions, :principal_office, :boolean, default: false
  end
end
