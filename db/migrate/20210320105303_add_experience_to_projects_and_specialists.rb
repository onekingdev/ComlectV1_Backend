# frozen_string_literal: true

class AddExperienceToProjectsAndSpecialists < ActiveRecord::Migration[6.0]
  def up
    rename_column :specialists, :years_of_experience, :experience
  end

  def down
    remove_column :specialists, :experience
    add_column :specialists, :years_of_experience, :integer, default: 0
  end
end
