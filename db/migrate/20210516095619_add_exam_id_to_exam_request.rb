# frozen_string_literal: true

class AddExamIdToExamRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :exam_requests, :exam_id, :integer, default: nil
  end
end
