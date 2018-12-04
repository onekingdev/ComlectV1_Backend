# frozen_string_literal: true

class AddLastActivityToForumQuestions < ActiveRecord::Migration
  def change
    add_column :forum_questions, :last_activity, :datetime, default: nil
  end
end
