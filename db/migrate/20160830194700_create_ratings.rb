# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[6.0]
  def change
    create_table :ratings do |t|
      t.references :project, index: true
      t.references :rater, polymorphic: true, index: true
      t.integer :value
      t.string :review

      t.timestamps null: false
    end
  end
end
