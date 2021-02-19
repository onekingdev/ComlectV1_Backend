# frozen_string_literal: true

class AddForumToRatings < ActiveRecord::Migration[6.0]
  def change
    add_column :ratings, :forum_rating, :boolean, default: false
    add_column :ratings, :specialist_id, :integer, default: nil
  end
end
