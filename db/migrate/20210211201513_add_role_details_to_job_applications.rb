# frozen_string_literal: true

class AddRoleDetailsToJobApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :job_applications, :role_details, :text, default: ''
  end
end
