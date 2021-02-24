# frozen_string_literal: true

class CreateFindings < ActiveRecord::Migration[6.0]
  def change
    create_table :findings do |t|
      t.integer :annual_report_id
      t.text :finding
      t.text :action
      t.integer :risk_lvl

      t.timestamps null: false
    end
  end
end
