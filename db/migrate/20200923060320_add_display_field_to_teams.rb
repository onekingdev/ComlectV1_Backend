# frozen_string_literal: true

class AddDisplayFieldToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :display, :boolean, default: true
  end
end
