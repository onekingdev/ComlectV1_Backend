# frozen_string_literal: true

class AddUsernameToSpecialistsAndBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :username, :string
    add_column :specialists, :username, :string
  end
end
