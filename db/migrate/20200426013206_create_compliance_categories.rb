# frozen_string_literal: true

class CreateComplianceCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :compliance_categories do |t|
      t.string :name
      t.text :checkboxes

      t.timestamps null: false
    end
  end
end
