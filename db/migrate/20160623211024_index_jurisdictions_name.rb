# frozen_string_literal: true

class IndexJurisdictionsName < ActiveRecord::Migration[6.0]
  def change
    add_index :jurisdictions, :name, unique: true
  end
end
