# frozen_string_literal: true

class AddSpecialistSubJurisdictionsToJurisdictions < ActiveRecord::Migration
  def change
    add_column :jurisdictions, :sub_jurisdictions_specialist, :text, default: ''
  end
end
