# frozen_string_literal: true

class MoveTurnkeyDescriptionToProjectTemplates < ActiveRecord::Migration
  def change
    remove_column :turnkey_solutions, :description
    add_column :project_templates, :public_description, :text
  end
end
