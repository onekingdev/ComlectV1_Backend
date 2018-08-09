# frozen_string_literal: true

class CreateTurnkeyPages < ActiveRecord::Migration
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
