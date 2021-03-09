# frozen_string_literal: true

class AddZeroFeeToSpecialists < ActiveRecord::Migration
  def change
    add_column :specialists, :zero_fee, :boolean, default: false
  end
end
