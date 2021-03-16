# frozen_string_literal: true

class AddSeatRoleToSpecialist < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :seat_role, :integer, default: 0
  end
end
