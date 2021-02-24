# frozen_string_literal: true

class RemoveNullConstraintFromStartsOnProjects < ActiveRecord::Migration[6.0]
  def change
    change_column_null :projects, :starts_on, true
  end
end
