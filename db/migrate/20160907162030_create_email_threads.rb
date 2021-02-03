# frozen_string_literal: true

class CreateEmailThreads < ActiveRecord::Migration
  def change
    create_table :email_threads do |t|
      t.references :business, index: true
      t.references :specialist, index: true
      t.string :thread_key

      t.timestamps null: false
    end
    add_index :email_threads, :thread_key, unique: true
    add_index :email_threads, %i[business_id specialist_id], unique: true
  end
end
