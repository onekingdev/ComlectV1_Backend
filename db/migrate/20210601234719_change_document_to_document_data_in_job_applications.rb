# frozen_string_literal: true

class ChangeDocumentToDocumentDataInJobApplications < ActiveRecord::Migration[6.0]
  def change
    rename_column :job_applications, :document, :document_data
  end
end
