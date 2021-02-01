# frozen_string_literal: true

class AddDashboardUnlockedToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :dashboard_unlocked, :boolean, default: false
  end
end
