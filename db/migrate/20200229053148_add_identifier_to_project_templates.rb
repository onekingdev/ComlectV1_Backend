# frozen_string_literal: true

class AddIdentifierToProjectTemplates < ActiveRecord::Migration
  def change
    add_column :project_templates, :identifier, :string, default: nil
  end
end
