# frozen_string_literal: true

class CreateForumVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :forum_votes do |t|
      t.integer :user_id
      t.integer :forum_answer_id
      t.boolean :upvote, default: true

      t.timestamps null: false
    end
  end
end
