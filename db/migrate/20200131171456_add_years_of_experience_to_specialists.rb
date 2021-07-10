# frozen_string_literal: true

class AddYearsOfExperienceToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :years_of_experience, :integer, default: nil
  end
end
