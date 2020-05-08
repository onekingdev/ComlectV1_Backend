# frozen_string_literal: true

class AddSubJurisdictionsToSpecialists < ActiveRecord::Migration
  def change
    add_column :specialists, :sub_jurisdictions, :string, default: nil
  end
end
