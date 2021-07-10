# frozen_string_literal: true

class AddRfpToJobApplication < ActiveRecord::Migration[6.0]
  def change
    add_column :job_applications, :key_deliverables, :string
    add_column :job_applications, :pricing_type, :string, default: 'hourly'
    add_column :job_applications, :payment_schedule, :string
    add_column :job_applications, :fixed_budget, :decimal
    add_column :job_applications, :hourly_rate, :decimal
    add_column :job_applications, :estimated_hours, :integer
  end
end
