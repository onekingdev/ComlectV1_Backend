# frozen_string_literal: true

class AddEstimatesToJobApplication < ActiveRecord::Migration[6.0]
  def change
    add_column :job_applications, :starts_on, :date
    add_column :job_applications, :ends_on, :date
  end
end
