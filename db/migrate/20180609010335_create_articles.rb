# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[6.0]
  def change
    create_table :articles do |t|
      t.string :src_title
      t.date :published_at
      t.string :title
      t.jsonb :image_data
      t.string :src_href

      t.timestamps null: false
    end
  end
end
