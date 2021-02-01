# frozen_string_literal: true

class ChangeDefaultToInterview < ActiveRecord::Migration[6.0]
  def change
    change_column :projects, :applicant_selection, :string, default: 'interview'
  end
end
