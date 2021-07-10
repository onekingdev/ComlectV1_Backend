# frozen_string_literal: true

class AddCategoryToPartnership < ActiveRecord::Migration[6.0]
  def change
    add_column :partnerships, :category, :string
  end
end
