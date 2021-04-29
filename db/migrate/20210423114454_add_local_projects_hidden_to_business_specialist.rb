# frozen_string_literal: true

class AddLocalProjectsHiddenToBusinessSpecialist < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :hidden_local_projects, :jsonb, default: []
  end
end
