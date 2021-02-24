# frozen_string_literal: true

class CreateFileFolders < ActiveRecord::Migration
  def change
    create_table :file_folders do |t|
      t.integer :business_id
      t.string :name
      t.integer :parent_id

      t.timestamps null: false
    end
  end
end
