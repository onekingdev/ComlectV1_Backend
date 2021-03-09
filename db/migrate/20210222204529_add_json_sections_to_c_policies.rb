# frozen_string_literal: true

class AddJsonSectionsToCPolicies < ActiveRecord::Migration[6.0]
  def change
    remove_column :compliance_policies, :section, :string
    remove_column :compliance_policies, :last_uploaded, :datetime
    remove_column :compliance_policies, :docs_count, :integer
    add_column :compliance_policies, :sections, :jsonb
  end
end
