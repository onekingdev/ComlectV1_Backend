# frozen_string_literal: true

class RemoveBusinessesIndustryColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :businesses, :industry, :string
  end
end
