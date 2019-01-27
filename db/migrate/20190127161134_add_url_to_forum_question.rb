# frozen_string_literal: true

class AddUrlToForumQuestion < ActiveRecord::Migration
  def change
    add_column :forum_questions, :url, :string, default: nil
  end
end
