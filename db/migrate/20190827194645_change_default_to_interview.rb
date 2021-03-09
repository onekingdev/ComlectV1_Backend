# frozen_string_literal: true

class ChangeDefaultToInterview < ActiveRecord::Migration
  def change
    change_column :projects, :applicant_selection, :string, default: 'interview'
  end
end
