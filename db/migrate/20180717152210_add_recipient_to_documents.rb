# frozen_string_literal: true

class AddRecipientToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :specialist_id, :integer
  end
end
