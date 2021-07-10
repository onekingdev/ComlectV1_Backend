# frozen_string_literal: true

class AddColorFieldToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :color, :string
  end
end
