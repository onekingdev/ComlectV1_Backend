# frozen_string_literal: true

class CreateAuditRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :audit_requests do |t|
      t.string :body

      t.timestamps null: false
    end
  end
end
