# frozen_string_literal: true

class ChangeProjectsTypeDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :projects, :type, 'one_off'
  end
end
