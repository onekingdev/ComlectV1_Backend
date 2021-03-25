# frozen_string_literal: true

class IndexSpecialistColumns < ActiveRecord::Migration
  def change
    add_index :specialists, :first_name
    add_index :specialists, :last_name
    add_index :specialists, :former_regulator
  end
end
