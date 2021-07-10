# frozen_string_literal: true

class AddZeroFeeToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :zero_fee, :boolean, default: false
  end
end
