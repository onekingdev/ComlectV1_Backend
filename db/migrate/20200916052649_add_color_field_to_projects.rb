# frozen_string_literal: true

class AddColorFieldToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :color, :string
  end
end
