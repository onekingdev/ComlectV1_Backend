# frozen_string_literal: true

class AddBusinessIdToPortedBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :ported_businesses, :business_id, :integer
    add_index :ported_businesses, :business_id
  end
end
