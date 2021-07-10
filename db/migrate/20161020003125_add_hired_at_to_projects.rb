# frozen_string_literal: true

class AddHiredAtToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :hired_at, :datetime
    add_index :projects, :hired_at
    reversible do |dir|
      dir.up do
        Project.where.not(specialist_id: nil).update_all 'hired_at = starts_on'
      end
    end
  end
end
