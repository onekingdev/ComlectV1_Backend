# frozen_string_literal: true

class CreateExams < ActiveRecord::Migration[6.0]
  def change
    create_table :exams do |t|
      t.string :name
      t.date :starts_on
      t.date :ends_on
      t.string :share_uuid, default: nil

      t.timestamps
    end
  end
end
