# frozen_string_literal: true

class AddRequesterToProjectExtensions < ActiveRecord::Migration[6.0]
  def change
    add_column :project_extensions, :requester, :string, default: nil
  end
end
