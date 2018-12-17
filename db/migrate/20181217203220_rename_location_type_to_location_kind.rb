# frozen_string_literal: true

class RenameLocationTypeToLocationKind < ActiveRecord::Migration
  def change
    rename_column :projects, :location_type, :location_kind
  end
end
