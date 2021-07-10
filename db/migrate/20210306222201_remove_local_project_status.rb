# frozen_string_literal: true

class RemoveLocalProjectStatus < ActiveRecord::Migration[6.0]
  def change
    remove_column :local_projects, :status, :string
  end
end
