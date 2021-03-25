# frozen_string_literal: true

class AddStatusToJobApplication < ActiveRecord::Migration[6.0]
  def change
    add_column :job_applications, :status, :string
  end
end
