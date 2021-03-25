# frozen_string_literal: true

class CreateForumQuestions < ActiveRecord::Migration
  def change
    create_table :forum_questions do |t|
      t.string :title
      t.text :body
      t.string :state
      t.integer :business_id

      t.timestamps null: false
    end
    create_join_table :forum_questions, :industries
    create_join_table :forum_questions, :jurisdictions
  end
end
