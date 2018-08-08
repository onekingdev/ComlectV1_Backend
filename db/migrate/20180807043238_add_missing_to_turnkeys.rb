# frozen_string_literal: true

class AddMissingToTurnkeys < ActiveRecord::Migration
  def change
    add_column :turnkey_solutions, :project_key_deliverables, :string
    add_column :turnkey_solutions, :project_pricing_type, :string
  end
end
