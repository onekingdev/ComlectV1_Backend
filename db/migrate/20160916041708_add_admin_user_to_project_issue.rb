# frozen_string_literal: true

class AddAdminUserToProjectIssue < ActiveRecord::Migration[6.0]
  def change
    add_reference :project_issues, :admin_user, index: true, foreign_key: true
  end
end
