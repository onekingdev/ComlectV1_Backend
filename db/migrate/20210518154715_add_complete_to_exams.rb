# frozen_string_literal: true

class AddCompleteToExams < ActiveRecord::Migration[6.0]
  def change
    add_column :exams, :complete, :boolean, default: false
  end
end
