# frozen_string_literal: true

class AddMinHourlyRateToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :min_hourly_rate, :integer, default: nil
  end
end
