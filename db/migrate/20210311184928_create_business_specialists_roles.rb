# frozen_string_literal: true

class CreateBusinessSpecialistsRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :business_specialists_roles do |t|
      t.references :business, null: false, foreign_key: true
      t.references :specialist, null: false, foreign_key: true
      t.integer :role, default: 0
    end
  end
end
