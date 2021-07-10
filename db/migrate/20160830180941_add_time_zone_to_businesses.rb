# frozen_string_literal: true

class AddTimeZoneToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :time_zone, :string
  end
end
