# frozen_string_literal: true

class CreateAuditDocs < ActiveRecord::Migration
  def change
    create_table :audit_docs do |t|
      t.jsonb :pdf_data
      t.jsonb :file_data
      t.integer :audit_request_id
      t.integer :business_id

      t.timestamps null: false
    end
  end
end
