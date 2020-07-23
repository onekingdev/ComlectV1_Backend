# frozen_string_literal: true

class CreateFileDocs < ActiveRecord::Migration
  def change
    create_table :file_docs do |t|
      t.integer :business_id
      t.integer :file_folder_id
      t.jsonb :file_data

      t.timestamps null: false
    end
  end
end
