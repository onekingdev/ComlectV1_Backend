# frozen_string_literal: true

class CreateLocalProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :local_projects do |t|
      t.integer :business_id
      t.string :title
      t.text :description
      t.date :starts_on
      t.date :ends_on
      t.string :status

      t.timestamps
    end
  end
end
