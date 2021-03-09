# frozen_string_literal: true

class ChangeProjectsDurationTypeDefault < ActiveRecord::Migration
  def change
    change_column_default :projects, :duration_type, 'custom'
  end
end
