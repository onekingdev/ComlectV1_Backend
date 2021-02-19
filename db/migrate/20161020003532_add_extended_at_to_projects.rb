# frozen_string_literal: true

class AddExtendedAtToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :extended_at, :datetime
    add_index :projects, :extended_at
  end
end
