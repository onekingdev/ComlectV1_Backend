# frozen_string_literal: true

class RemoveBusinessesIndustryColumn < ActiveRecord::Migration
  def change
    remove_column :businesses, :industry, :string
  end
end
