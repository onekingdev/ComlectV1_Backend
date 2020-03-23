# frozen_string_literal: true

class CreateBusinessChanges < ActiveRecord::Migration
  def change
    create_table :business_changes do |t|
      t.text :change
      t.integer :annual_report_id

      t.timestamps null: false
    end
  end
end
