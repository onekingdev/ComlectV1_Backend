class RemoveNotNullFromDocuments < ActiveRecord::Migration[6.0]
  def change
    remove_column :documents, :local_project_id
  end
end
