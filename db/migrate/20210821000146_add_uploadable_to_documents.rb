class AddUploadableToDocuments < ActiveRecord::Migration[6.0]
  def change
    add_column :documents, :uploadable_type, :string, default: nil
    add_column :documents, :uploadable_id, :integer, default: nil
  end
end
