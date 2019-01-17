# frozen_string_literal: true

class AddForumToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :forum_rating, :boolean, default: false
    add_column :ratings, :specialist_id, :integer, default: nil
  end
end
