# frozen_string_literal: true

class AddRequesterToProjectEnds < ActiveRecord::Migration[6.0]
  def change
    add_column :project_ends, :requester, :string, default: nil
  end
end
