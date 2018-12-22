# frozen_string_literal: true

class AddEstimatesToJobApplication < ActiveRecord::Migration
  def change
    add_column :job_applications, :starts_on, :date
    add_column :job_applications, :ends_on, :date
    add_column :job_applications, :estimated_days, :integer
  end
end
