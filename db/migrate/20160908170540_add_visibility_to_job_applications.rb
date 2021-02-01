# frozen_string_literal: true

class AddVisibilityToJobApplications < ActiveRecord::Migration
  def change
    add_column :job_applications, :visibility, :string
  end
end
