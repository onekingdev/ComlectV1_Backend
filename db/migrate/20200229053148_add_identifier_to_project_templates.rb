# frozen_string_literal: true

class AddIdentifierToProjectTemplates < ActiveRecord::Migration[6.0]
  def change
    add_column :project_templates, :identifier, :string, default: nil
  end
end
