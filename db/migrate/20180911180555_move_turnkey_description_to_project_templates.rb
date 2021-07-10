# frozen_string_literal: true

class MoveTurnkeyDescriptionToProjectTemplates < ActiveRecord::Migration[6.0]
  def change
    remove_column :turnkey_solutions, :description
    add_column :project_templates, :public_description, :text
  end
end
