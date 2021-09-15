class AddOwnerToFilesAndFolders < ActiveRecord::Migration[6.0]
  def change
    add_column :file_folders, :owner, :string
    add_column :file_docs, :owner, :string
  end
end
