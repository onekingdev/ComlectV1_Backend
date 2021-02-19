# frozen_string_literal: true

class AddSpecialistProjectTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :project_types, :string, default: nil
  end
end
