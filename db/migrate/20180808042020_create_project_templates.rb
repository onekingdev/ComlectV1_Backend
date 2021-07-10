# frozen_string_literal: true

class CreateProjectTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :project_templates do |t|
      t.string :title
      t.string :project_type
      t.string :location_type
      t.string :description
      t.string :payment_schedule
      t.decimal :fixed_budget
      t.decimal :hourly_rate
      t.integer :estimated_hours
      t.boolean :only_regulators
      t.integer :annual_salary
      t.string :fee_type
      t.integer :minimum_experience
      t.string :duration_type
      t.integer :estimated_days
      t.integer :turnkey_solution_id
      t.string :flavor
      t.string :key_deliverables
      t.string :pricing_type

      t.timestamps null: false
    end
    create_join_table :project_templates, :industries
    create_join_table :project_templates, :jurisdictions
  end
end
