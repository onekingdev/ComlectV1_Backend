# frozen_string_literal: true

class AddUpvotesCountForForum < ActiveRecord::Migration
  def change
    add_column :forum_answers, :upvotes_cnt, :integer, default: 0
  end
end
