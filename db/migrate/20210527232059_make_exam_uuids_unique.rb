# frozen_string_literal: true

class MakeExamUuidsUnique < ActiveRecord::Migration[6.0]
  def change
    add_index :exams, :share_uuid, unique: true
  end
end
