# frozen_string_literal: true

class AddPublishedAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :published_at, :datetime
    add_index :projects, :published_at
    reversible do |dir|
      dir.up do
        Project.where(status: %w[published complete]).update_all 'published_at = created_at'
      end
    end
  end
end
