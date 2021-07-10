# frozen_string_literal: true

class CreateTurnkeyPages < ActiveRecord::Migration[6.0]
  def change
    create_table :turnkey_pages do |t|
      t.string :title
      t.string :url
      t.text :description
      t.string :cost

      t.timestamps null: false
    end
  end
end
