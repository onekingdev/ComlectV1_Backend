# frozen_string_literal: true

class AddNameToFileDocs < ActiveRecord::Migration[6.0]
  def change
    add_column :file_docs, :name, :string, default: nil
  end
end
