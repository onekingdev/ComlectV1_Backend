# frozen_string_literal: true

class AddDocumentToJobApp < ActiveRecord::Migration[6.0]
  def change
    add_column :job_applications, :document, :jsonb, default: nil
  end
end
