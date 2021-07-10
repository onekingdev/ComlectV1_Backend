# frozen_string_literal: true

class CreateReviewCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :review_categories do |t|
      t.integer :annual_report_id
      t.boolean :complete, default: false
      t.string :name, default: ''
      t.jsonb :review_topics

      t.timestamps
    end
  end
end
