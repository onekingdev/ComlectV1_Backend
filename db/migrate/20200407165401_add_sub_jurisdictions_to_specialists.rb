# frozen_string_literal: true

class AddSubJurisdictionsToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :sub_jurisdictions, :string, default: nil
  end
end
