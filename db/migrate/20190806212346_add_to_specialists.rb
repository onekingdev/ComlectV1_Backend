# frozen_string_literal: true

class AddToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :specialist_risks, :string, default: nil
    add_column :specialists, :specialist_other, :string, default: nil
    add_column :specialists, :sub_industries, :string, default: nil
  end
end
