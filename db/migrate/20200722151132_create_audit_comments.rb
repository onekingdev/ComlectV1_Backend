# frozen_string_literal: true

class CreateAuditComments < ActiveRecord::Migration[6.0]
  def change
    create_table :audit_comments do |t|
      t.integer :audit_request_id
      t.integer :business_id
      t.text :body

      t.timestamps null: false
    end
  end
end
