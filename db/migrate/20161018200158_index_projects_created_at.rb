# frozen_string_literal: true

class IndexProjectsCreatedAt < ActiveRecord::Migration
  def change
    add_index :projects, :created_at
  end
end
