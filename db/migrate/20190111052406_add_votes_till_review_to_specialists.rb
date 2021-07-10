# frozen_string_literal: true

class AddVotesTillReviewToSpecialists < ActiveRecord::Migration[6.0]
  def change
    add_column :specialists, :forum_upvotes_for_review, :integer, default: 0
  end
end
