# frozen_string_literal: true

class AddDurationTypeToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :duration_type, :string, default: 'asap'
    add_column :projects, :estimated_days, :integer
  end
end
