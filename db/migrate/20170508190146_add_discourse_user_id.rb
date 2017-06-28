# frozen_string_literal: true

class AddDiscourseUserId < ActiveRecord::Migration
  def change
    add_column :specialists, :discourse_user_id, :integer
    add_column :businesses, :discourse_user_id, :integer
  end
end
