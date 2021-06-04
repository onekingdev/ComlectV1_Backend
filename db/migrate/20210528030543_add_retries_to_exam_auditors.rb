# frozen_string_literal: true

class AddRetriesToExamAuditors < ActiveRecord::Migration[6.0]
  def change
    add_column :exam_auditors, :retries, :integer, default: 0
  end
end
