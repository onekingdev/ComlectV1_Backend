# frozen_string_literal: true

class AddLockedToFileFolders < ActiveRecord::Migration
  def change
    add_column :file_folders, :locked, :boolean, default: false
  end
end
