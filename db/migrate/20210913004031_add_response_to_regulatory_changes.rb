class AddResponseToRegulatoryChanges < ActiveRecord::Migration[6.0]
  def change
    add_column :regulatory_changes, :response, :text, default: nil
  end
end
