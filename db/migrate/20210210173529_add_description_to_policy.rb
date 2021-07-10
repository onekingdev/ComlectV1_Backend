# frozen_string_literal: true

class AddDescriptionToPolicy < ActiveRecord::Migration[6.0]
  def change
    add_column :compliance_policies, :description, :text, default: ''
  end
end
