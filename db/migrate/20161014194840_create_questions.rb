# frozen_string_literal: true

class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :project, index: true, null: false
      t.text :text

      t.timestamps null: false
    end
  end
end
