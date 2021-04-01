# frozen_string_literal: true

class AddEndDateOnlyToProjectExtensions < ActiveRecord::Migration[6.0]
  def change
    add_column :project_extensions, :ends_on_only, :boolean, default: false
  end
end
