# frozen_string_literal: true

class AddDescriptionAndHoweverToComplianceCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :compliance_categories, :description, :text, default: ''
    add_column :compliance_categories, :however, :text, default: ''
  end
end
