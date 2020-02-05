# frozen_string_literal: true

class CreateAnnualReviewEmployees < ActiveRecord::Migration
  def change
    create_table :annual_review_employees do |t|
      t.string :name
      t.string :title
      t.string :department
      t.integer :annual_report_id

      t.timestamps null: false
    end
  end
end
