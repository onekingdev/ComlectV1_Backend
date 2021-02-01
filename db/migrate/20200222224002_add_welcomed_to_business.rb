# frozen_string_literal: true

class AddWelcomedToBusiness < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :welcomed, :boolean, default: false
  end
end
