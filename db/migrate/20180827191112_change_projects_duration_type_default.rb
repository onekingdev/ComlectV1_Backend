# frozen_string_literal: true

class ChangeProjectsDurationTypeDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :projects, :duration_type, 'custom'
  end
end
