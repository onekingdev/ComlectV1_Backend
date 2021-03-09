# frozen_string_literal: true

class CreateEducationHistories < ActiveRecord::Migration
  def change
    create_table :education_histories do |t|
      t.references :specialist, index: true
      t.string :institution
      t.string :degree
      t.integer :year

      t.timestamps null: false
    end
  end
end
