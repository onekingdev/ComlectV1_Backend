# frozen_string_literal: true

class IndexDeletedColsOnUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :deleted
    add_index :users, :deleted_at
  end
end
