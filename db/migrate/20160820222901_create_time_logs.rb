# frozen_string_literal: true

class CreateTimeLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :time_logs do |t|
      t.references :timesheet, index: true
      t.string :description
      t.decimal :hours

      t.timestamps null: false
    end
  end
end
