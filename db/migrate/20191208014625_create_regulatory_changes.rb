# frozen_string_literal: true

class CreateRegulatoryChanges < ActiveRecord::Migration
  def change
    create_table :regulatory_changes do |t|
      t.integer :annual_report_id
      t.text :change
      t.text :response

      t.timestamps null: false
    end
  end
end
