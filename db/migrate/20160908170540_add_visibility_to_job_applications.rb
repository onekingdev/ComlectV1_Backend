# frozen_string_literal: true

class AddVisibilityToJobApplications < ActiveRecord::Migration[6.0]
  def change
    add_column :job_applications, :visibility, :string
  end
end
