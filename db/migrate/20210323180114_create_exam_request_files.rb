# frozen_string_literal: true

class CreateExamRequestFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :exam_request_files do |t|
      t.integer :exam_request_id
      t.jsonb :file_data
      t.string :name

      t.timestamps
    end
  end
end
