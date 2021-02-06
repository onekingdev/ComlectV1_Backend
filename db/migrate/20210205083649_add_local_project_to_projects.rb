# frozen_string_literal: true

class AddLocalProjectToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :local_project_id, :integer, default: nil
  end
end
