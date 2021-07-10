# frozen_string_literal: true

class CreateFavorites < ActiveRecord::Migration[6.0]
  def change
    create_table :favorites do |t|
      t.references :owner, polymorphic: true, index: true
      t.references :favorited, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_index :favorites, %i[owner_id owner_type favorited_id favorited_type], unique: true, name: 'favorites_unique'
  end
end
