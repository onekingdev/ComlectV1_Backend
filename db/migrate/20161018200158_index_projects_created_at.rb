# frozen_string_literal: true

class IndexProjectsCreatedAt < ActiveRecord::Migration[6.0]
  def change
    add_index :projects, :created_at
  end
end
