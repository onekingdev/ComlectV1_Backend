# frozen_string_literal: true

class AddQnaViewsLeftToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :qna_viewed_questions, :integer, array: true, default: []
    add_column :businesses, :qna_views_left, :integer, default: 5
  end
end
