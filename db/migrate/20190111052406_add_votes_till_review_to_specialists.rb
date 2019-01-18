# frozen_string_literal: true

class AddVotesTillReviewToSpecialists < ActiveRecord::Migration
  def change
    add_column :specialists, :forum_upvotes_for_review, :integer, default: 0
  end
end
