# frozen_string_literal: true

class RenameProjectExtensionColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column :project_extensions, :new_end_date, :ends_on
    rename_column :project_extensions, :new_starts_on, :starts_on
  end
end
