# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :thread, index: true, polymorphic: true
      t.references :sender, index: true, polymorphic: true
      t.references :recipient, index: true, polymorphic: true
      t.string :message
      t.jsonb :file_data

      t.timestamps null: false
    end
  end
end
