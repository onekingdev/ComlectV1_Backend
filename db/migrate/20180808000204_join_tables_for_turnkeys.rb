# frozen_string_literal: true

class JoinTablesForTurnkeys < ActiveRecord::Migration
  def change
    create_join_table :turnkey_solutions, :industries
    create_join_table :turnkey_solutions, :jurisdictions
    rename_column :turnkey_solutions, :industries, :industries_enabled
    rename_column :turnkey_solutions, :jurisdictions, :jurisdictions_enabled
    remove_column :turnkey_solutions, :project_jurisdictions
    remove_column :turnkey_solutions, :project_industries
  end
end
