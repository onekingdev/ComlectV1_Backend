# frozen_string_literal: true

class CreateAnnualReports < ActiveRecord::Migration
  def change
    create_table :annual_reports do |t|
      t.date :exam_start
      t.date :exam_end
      t.date :review_start
      t.date :review_end
      t.text :employees_interviewed
      t.text :business_change
      t.text :regulatory_change
      t.text :regulatory_response
      t.string :cof_bits
      t.text :findings
      t.integer :tailored_lvl
      t.text :comments

      t.timestamps null: false
    end
  end
end
