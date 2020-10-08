# frozen_string_literal: true

class AddZipDataToFileFolders < ActiveRecord::Migration
  def change
    add_column :file_folders, :zip_data, :jsonb
  end
end
