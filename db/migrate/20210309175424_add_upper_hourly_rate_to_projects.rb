# frozen_string_literal: true

class AddUpperHourlyRateToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :upper_hourly_rate, :decimal
  end
end
