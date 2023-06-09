# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.references :question, index: true, null: false
      t.text :text

      t.timestamps null: false
    end
  end
end
