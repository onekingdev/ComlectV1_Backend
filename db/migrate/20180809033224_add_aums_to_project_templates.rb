# frozen_string_literal: true

class AddAumsToProjectTemplates < ActiveRecord::Migration
  def change
    add_column :project_templates, :title_aum, :string
    add_column :project_templates, :description_aum, :string
  end
end
