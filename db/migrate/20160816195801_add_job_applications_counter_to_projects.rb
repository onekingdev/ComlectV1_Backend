# frozen_string_literal: true

class AddJobApplicationsCounterToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :job_applications_count, :integer, null: false, default: 0
  end
end
