# frozen_string_literal: true

class AddRiaDashboardToBusiness < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :ria_dashboard, :boolean, default: false
  end
end
