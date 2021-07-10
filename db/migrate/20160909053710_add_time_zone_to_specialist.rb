# frozen_string_literal: true

class AddTimeZoneToSpecialist < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :time_zone, :string
  end
end
