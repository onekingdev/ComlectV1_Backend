# frozen_string_literal: true

class AddCheckboxIndexToFindings < ActiveRecord::Migration
  def change
    add_column :findings, :checkbox_index, :integer, default: nil
  end
end
