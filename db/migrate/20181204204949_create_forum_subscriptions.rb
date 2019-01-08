# frozen_string_literal: true

class CreateForumSubscriptions < ActiveRecord::Migration
  def change
    create_table :forum_subscriptions do |t|
      t.belongs_to :business, index: true
      t.integer :billing_type, default: 0
      t.integer :level, default: 0
      t.boolean :suspended, default: false
      t.datetime :expiration
      t.timestamps null: false
    end
  end
end
