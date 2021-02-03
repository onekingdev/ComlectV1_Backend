# frozen_string_literal: true

class AddBusinessFeeFreeToProjectTemplate < ActiveRecord::Migration
  def change
    add_column :project_templates, :business_fee_free, :boolean, default: false
  end
end
