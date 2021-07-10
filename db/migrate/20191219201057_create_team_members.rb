# frozen_string_literal: true

class CreateTeamMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :team_members do |t|
      t.integer :team_id
      t.string :name
      t.string :department
      t.string :email

      t.timestamps null: false
    end
  end
end
