# frozen_string_literal: true

class CreateJurisdictions < ActiveRecord::Migration[6.0]
  def change
    create_table :jurisdictions do |t|
      t.string :name
      t.timestamps null: false
    end

    create_join_table :businesses, :jurisdictions
  end
end
