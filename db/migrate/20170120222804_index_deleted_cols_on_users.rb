# frozen_string_literal: true
class IndexDeletedColsOnUsers < ActiveRecord::Migration
  def change
    add_index :users, :deleted
    add_index :users, :deleted_at
  end
end
