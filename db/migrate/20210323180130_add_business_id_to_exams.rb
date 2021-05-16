# frozen_string_literal: true

class AddBusinessIdToExams < ActiveRecord::Migration[6.0]
  def change
    add_column :exams, :business_id, :integer
  end
end
