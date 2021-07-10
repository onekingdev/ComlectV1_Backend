# frozen_string_literal: true

class AddLockedToFileFolders < ActiveRecord::Migration[6.0]
  def change
    add_column :file_folders, :locked, :boolean, default: false
  end
end
