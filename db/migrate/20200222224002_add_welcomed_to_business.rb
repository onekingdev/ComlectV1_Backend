# frozen_string_literal: true

class AddWelcomedToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :welcomed, :boolean, default: false
  end
end
