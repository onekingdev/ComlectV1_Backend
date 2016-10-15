# frozen_string_literal: true
class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.references :flagged_content, index: true, polymorphic: true
      t.references :flagger, index: true, polymorphic: true
      t.text :reason

      t.timestamps null: false
    end
  end
end
