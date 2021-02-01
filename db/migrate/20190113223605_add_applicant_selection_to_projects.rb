# frozen_string_literal: true

class AddApplicantSelectionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :applicant_selection, :string, default: 'auto_match'
  end
end
