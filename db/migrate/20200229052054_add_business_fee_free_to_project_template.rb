# frozen_string_literal: true

class AddBusinessFeeFreeToProjectTemplate < ActiveRecord::Migration[6.0]
  def change
    add_column :project_templates, :business_fee_free, :boolean, default: false
  end
end
