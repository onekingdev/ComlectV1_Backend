# frozen_string_literal: true

class AddDurationTypeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :duration_type, :string, null: false, default: :asap
    add_column :projects, :estimated_days, :integer
  end
end
