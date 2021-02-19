# frozen_string_literal: true

class AddDocData < ActiveRecord::Migration
  def change
    add_column :compliance_policy_docs, :doc_data, :jsonb, default: nil
  end
end
