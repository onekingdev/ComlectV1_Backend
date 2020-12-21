# frozen_string_literal: true

class AddCallBookedToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :call_booked, :boolean, default: false
  end
end
