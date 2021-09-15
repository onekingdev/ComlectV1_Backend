class AddSizeToFileAndFolder < ActiveRecord::Migration[6.0]
  def change
    add_column :file_folders, :size, :integer
    add_column :file_docs, :size, :integer
  end
end
