# frozen_string_literal: true

class AddExpiresAtToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :expires_at, :datetime
    add_index :projects, :expires_at
  end
end
