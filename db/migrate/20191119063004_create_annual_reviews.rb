# frozen_string_literal: true

class CreateAnnualReviews < ActiveRecord::Migration
  def change
    create_table :annual_reviews do |t|
      t.integer :business_id
      t.jsonb :file_data
      t.integer :year

      t.timestamps null: false
    end
  end
end
