# frozen_string_literal: true

class AddRiaDashboardToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :ria_dashboard, :boolean, default: false
  end
end
