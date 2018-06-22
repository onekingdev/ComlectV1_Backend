# frozen_string_literal: true

class AddStartsAsapToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :starts_asap, :boolean, default: false
  end
end
