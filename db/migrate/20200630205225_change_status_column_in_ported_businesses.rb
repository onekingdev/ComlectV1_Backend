# frozen_string_literal: true

class ChangeStatusColumnInPortedBusinesses < ActiveRecord::Migration
  def change
    remove_column :ported_businesses, :status
    add_column :ported_businesses, :status, :integer, default: 0
  end
end
