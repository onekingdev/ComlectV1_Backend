# frozen_string_literal: true

class AddFileToForumAnswer < ActiveRecord::Migration
  def change
    add_column :forum_answers, :file_data, :jsonb
  end
end
