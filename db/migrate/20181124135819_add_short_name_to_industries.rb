# frozen_string_literal: true

class AddShortNameToIndustries < ActiveRecord::Migration[6.0]
  def change
    add_column :industries, :short_name, :string, default: nil
  end
end
