# frozen_string_literal: true

class AddNameToFileDocs < ActiveRecord::Migration
  def change
    add_column :file_docs, :name, :string, default: nil
  end
end
