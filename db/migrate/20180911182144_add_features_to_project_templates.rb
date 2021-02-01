# frozen_string_literal: true

class AddFeaturesToProjectTemplates < ActiveRecord::Migration[6.0]
  def change
    remove_column :turnkey_solutions, :features
    add_column :project_templates, :public_features, :text
  end
end
