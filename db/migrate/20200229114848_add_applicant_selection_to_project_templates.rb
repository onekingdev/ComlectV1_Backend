# frozen_string_literal: true

class AddApplicantSelectionToProjectTemplates < ActiveRecord::Migration[6.0]
  def change
    add_column :project_templates, :applicant_selection, :string, default: 'interview'
  end
end
