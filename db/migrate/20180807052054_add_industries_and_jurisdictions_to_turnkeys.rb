# frozen_string_literal: true

class AddIndustriesAndJurisdictionsToTurnkeys < ActiveRecord::Migration
  def change
    add_column :turnkey_solutions, :project_industries, :string
    add_column :turnkey_solutions, :project_jurisdictions, :string
  end
end
