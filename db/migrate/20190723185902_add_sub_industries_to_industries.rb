# frozen_string_literal: true

class AddSubIndustriesToIndustries < ActiveRecord::Migration[6.0]
  def change
    add_column :industries, :sub_industries, :text, default: ''
  end
end
