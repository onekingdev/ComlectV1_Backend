# frozen_string_literal: true

class AddShortNameToIndustries < ActiveRecord::Migration
  def change
    add_column :industries, :short_name, :string, default: nil
  end
end
