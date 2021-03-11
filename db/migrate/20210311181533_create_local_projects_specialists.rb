class CreateLocalProjectsSpecialists < ActiveRecord::Migration[6.0]
  def change
    create_table :local_projects_specialists do |t|
      t.references :local_project, null: false, foreign_key: true
      t.references :specialist, null: false, foreign_key: true
    end
  end
end
