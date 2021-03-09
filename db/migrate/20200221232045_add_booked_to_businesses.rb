# frozen_string_literal: true

class AddBookedToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :onboard_call_booked, :boolean, default: false
  end
end
