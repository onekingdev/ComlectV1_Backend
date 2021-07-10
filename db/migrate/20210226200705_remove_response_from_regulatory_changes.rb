# frozen_string_literal: true

class RemoveResponseFromRegulatoryChanges < ActiveRecord::Migration[6.0]
  def change
    remove_column :regulatory_changes, :response, :text
  end
end
