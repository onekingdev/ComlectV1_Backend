# frozen_string_literal: true

class AddMutedProjectsToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :muted_projects, :text, default: [].to_yaml
  end
end
