# frozen_string_literal: true
class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
    add_index :skills, :name, unique: true

    create_join_table :projects, :skills
    add_index :projects_skills, %i(project_id skill_id), unique: true
  end
end
