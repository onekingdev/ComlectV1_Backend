# frozen_string_literal: true

class AddTotalAssetsToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :total_assets, :decimal, default: nil
  end
end
