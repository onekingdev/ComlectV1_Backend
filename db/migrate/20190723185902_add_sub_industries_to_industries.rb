# frozen_string_literal: true

class AddSubIndustriesToIndustries < ActiveRecord::Migration
  def change
    add_column :industries, :sub_industries, :text, default: ''
  end
end
