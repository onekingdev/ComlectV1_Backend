# frozen_string_literal: true
class CreateProjects < ActiveRecord::Migration
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def change
    create_table :projects do |t|
      t.references :business, index: true, null: false
      t.string :type, null: false, default: 'one-off'
      t.string :status, null: false, default: 'draft'
      t.string :title, null: false
      t.string :location_type, null: false
      t.string :location
      t.string :description, null: false
      t.string :key_deliverables, null: false
      t.date :starts_on, null: false
      t.date :ends_on, null: false
      t.string :pricing_type, null: false, default: 'hourly'
      t.string :payment_schedule
      t.decimal :fixed_budget
      t.decimal :hourly_rate
      t.integer :estimated_hours
      t.string :minimum_experience
      t.boolean :only_regulators

      t.timestamps null: false
    end
    add_index :projects, :status

    create_join_table :industries, :projects
    add_index :industries_projects, %i(industry_id project_id), unique: true
    create_join_table :jurisdictions, :projects
    add_index :jurisdictions_projects, %i(jurisdiction_id project_id), unique: true
  end
end
