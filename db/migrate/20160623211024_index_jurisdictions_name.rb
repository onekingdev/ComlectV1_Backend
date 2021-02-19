# frozen_string_literal: true

class IndexJurisdictionsName < ActiveRecord::Migration
  def change
    add_index :jurisdictions, :name, unique: true
  end
end
