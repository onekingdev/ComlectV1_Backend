# frozen_string_literal: true

class AddDisplayFieldToTeams < ActiveRecord::Migration[6.0]
  def change
    add_column :teams, :display, :boolean, default: true
  end
end
