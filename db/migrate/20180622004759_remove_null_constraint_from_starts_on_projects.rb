# frozen_string_literal: true

class RemoveNullConstraintFromStartsOnProjects < ActiveRecord::Migration
  def change
    change_column_null :projects, :starts_on, true
  end
end
