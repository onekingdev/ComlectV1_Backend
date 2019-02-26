# frozen_string_literal: true

class ChangeQnaViews < ActiveRecord::Migration
  def change
    change_column :businesses, :qna_views_left, :integer, default: 3
  end
end
