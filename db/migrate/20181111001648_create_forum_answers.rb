# frozen_string_literal: true

class CreateForumAnswers < ActiveRecord::Migration
  def change
    create_table :forum_answers do |t|
      t.integer :user_id
      t.text :body
      t.integer :forum_question_id
      t.integer :reply_to

      t.timestamps null: false
    end
  end
end
