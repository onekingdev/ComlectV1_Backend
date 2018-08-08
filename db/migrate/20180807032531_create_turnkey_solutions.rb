# frozen_string_literal: true

class CreateTurnkeySolutions < ActiveRecord::Migration
  def change
    create_table :turnkey_solutions do |t|
      t.string :title
      t.string :range
      t.boolean :era
      t.boolean :sma
      t.boolean :fund
      t.boolean :industries
      t.boolean :jurisdictions
      t.integer :hours
      t.text :description
      t.text :features
      t.string :project_title
      t.string :project_type
      t.string :project_location_type
      t.string :project_location
      t.string :project_description
      t.string :project_payment_schedule
      t.decimal :project_fixed_budget
      t.decimal :project_hourly_rate
      t.integer :project_estimated_hours
      t.boolean :project_only_regulators
      t.integer :project_annual_salary
      t.string :project_fee_type
      t.integer :project_minimum_experience
      t.string :project_duration_type
      t.integer :project_estimated_days

      t.timestamps null: false
    end
  end
end
