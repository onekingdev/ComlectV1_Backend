# frozen_string_literal: true

class AddIndexesToProjects < ActiveRecord::Migration[6.0]
  def change
    add_index :projects, :starts_on
    add_index :projects, :minimum_experience
    add_index :projects, :only_regulators
  end
end
