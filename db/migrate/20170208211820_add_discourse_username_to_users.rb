# frozen_string_literal: true

class AddDiscourseUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :businesses, :discourse_username, :string
    add_index :businesses, :discourse_username
    add_column :specialists, :discourse_username, :string
    add_index :specialists, :discourse_username
  end
end
