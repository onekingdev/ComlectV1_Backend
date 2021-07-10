# frozen_string_literal: true

class AddDeletedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :deleted, :boolean, null: false, default: false
    add_index :users, :deleted
  end
end
