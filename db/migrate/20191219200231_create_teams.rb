# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.integer :business_id
      t.string :name

      t.timestamps null: false
    end
  end
end
