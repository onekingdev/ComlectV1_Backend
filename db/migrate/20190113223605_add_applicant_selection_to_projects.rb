# frozen_string_literal: true

class AddApplicantSelectionToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :applicant_selection, :string, default: 'auto_match'
  end
end
