# frozen_string_literal: true

class AddMetricsIndexesToProjects < ActiveRecord::Migration[6.0]
  def change
    add_index :projects, :type
    add_index :projects, :pricing_type
    add_index :projects, :payment_schedule
    add_index :projects, :fixed_budget
    add_index :projects, :hourly_rate
    add_index :projects, :estimated_hours
    add_index :projects, :annual_salary
    add_index :projects, :fee_type
  end
end
