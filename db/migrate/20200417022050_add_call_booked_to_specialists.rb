# frozen_string_literal: true

class AddCallBookedToSpecialists < ActiveRecord::Migration
  def change
    add_column :specialists, :call_booked, :boolean, default: false
  end
end
