# frozen_string_literal: true

class CreateSpecialists < ActiveRecord::Migration[6.0]
  def change
    create_table :specialists do |t|
      t.references :user, index: true
      t.string :first_name
      t.string :last_name
      t.string :country
      t.string :state
      t.string :city
      t.string :zipcode
      t.string :phone
      t.string :linkedin_link
      t.boolean :former_regulator, null: false, default: false
      t.jsonb :photo_data
      t.jsonb :resume_data
      t.string :certifications
      t.string :visibility, null: false, default: 'public'

      t.timestamps null: false
    end

    create_join_table :jurisdictions, :specialists
    add_index :jurisdictions_specialists,
              %i[jurisdiction_id specialist_id],
              unique: true,
              name: 'jurisdictions_specialists_unique'
    create_join_table :industries, :specialists
    add_index :industries_specialists,
              %i[industry_id specialist_id],
              unique: true,
              name: 'industries_specialists_unique'

    create_join_table :skills, :specialists
    add_index :skills_specialists, %i[skill_id specialist_id], unique: true
  end
end
