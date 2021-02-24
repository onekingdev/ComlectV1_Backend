# frozen_string_literal: true

class AddSubJurisdictionsOtherToSpecialists < ActiveRecord::Migration
  def change
    add_column :specialists, :sub_jurisdictions_other, :string, default: nil
  end
end
