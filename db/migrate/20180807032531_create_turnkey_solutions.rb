# frozen_string_literal: true

class CreateTurnkeySolutions < ActiveRecord::Migration
  def change
    create_table :turnkey_solutions do |t|
      t.string :title
      t.integer :turnkey_page_id
      t.string :range
      t.boolean :aum_enabled
      t.boolean :principal_office
      t.boolean :industries_enabled
      t.boolean :jurisdictions_enabled
      t.boolean :hours_enabled
      t.text :description
      t.text :features

      t.timestamps null: false
    end
  end
end
