# frozen_string_literal: true
class CreateJobApplications < ActiveRecord::Migration
  def change
    create_table :job_applications do |t|
      t.references :specialist, index: true
      t.references :project, index: true
      t.string :message

      t.timestamps null: false
    end
    add_index :job_applications, %i(specialist_id project_id), unique: true
  end
end
