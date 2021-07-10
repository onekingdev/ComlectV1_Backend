# frozen_string_literal: true

class AddDeletedToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :deleted, :boolean, null: false, default: false
  end
end
