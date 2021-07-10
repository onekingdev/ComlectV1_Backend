# frozen_string_literal: true

class CreateSpecialistTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :specialist_teams do |t|
      t.belongs_to :manager, index: true, null: false
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
