# frozen_string_literal: true

class AddCompletedAtToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :completed_at, :datetime
    add_index :projects, :completed_at
    reversible do |dir|
      dir.up do
        Project.complete.update_all completed_at: Time.zone.now
      end
    end
  end
end
