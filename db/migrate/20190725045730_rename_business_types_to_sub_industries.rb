# frozen_string_literal: true

class RenameBusinessTypesToSubIndustries < ActiveRecord::Migration[6.0]
  def change
    rename_column :businesses, :business_types_a, :sub_industries
    remove_column :businesses, :business_types_b
  end
end
