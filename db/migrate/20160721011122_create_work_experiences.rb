# frozen_string_literal: true

class CreateWorkExperiences < ActiveRecord::Migration[6.0]
  def change
    create_table :work_experiences do |t|
      t.references :specialist, index: true
      t.string :company
      t.string :job_title
      t.string :location
      t.date :from
      t.date :to
      t.boolean :current, null: false, default: false
      t.boolean :compliance, null: false, default: false
      t.string :description

      t.timestamps null: false
    end
  end
end
