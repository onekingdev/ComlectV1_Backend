# frozen_string_literal: true

class AddFindingsEverywhereToComplianceCategories < ActiveRecord::Migration
  def change
    add_column :compliance_categories, :findings_everywhere, :text, default: ''
  end
end
