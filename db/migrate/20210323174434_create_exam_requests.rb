# frozen_string_literal: true

class CreateExamRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :exam_requests do |t|
      t.string :name
      t.text :details
      t.jsonb :text_items
      t.boolean :complete, default: false
      t.boolean :shared, default: false

      t.timestamps
    end
  end
end
