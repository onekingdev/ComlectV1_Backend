# frozen_string_literal: true
class AddDeletedToSpecialists < ActiveRecord::Migration
  def change
    add_column :specialists, :deleted, :boolean, null: false, default: false
  end
end
