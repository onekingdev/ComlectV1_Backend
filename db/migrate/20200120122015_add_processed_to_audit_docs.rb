# frozen_string_literal: true

class AddProcessedToAuditDocs < ActiveRecord::Migration
  def change
    add_column :audit_docs, :processed, :boolean, default: false
  end
end
