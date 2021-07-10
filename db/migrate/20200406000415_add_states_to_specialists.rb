# frozen_string_literal: true

class AddStatesToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :jurisdiction_states_usa, :string, default: ''
    add_column :specialists, :jurisdiction_states_canada, :string, default: ''
  end
end
