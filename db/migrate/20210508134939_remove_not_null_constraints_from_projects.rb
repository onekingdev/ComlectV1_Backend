# frozen_string_literal: true

class RemoveNotNullConstraintsFromProjects < ActiveRecord::Migration[6.0]
  def change
    change_column_null :projects, :title, true
    change_column_null :projects, :description, true
  end
end
