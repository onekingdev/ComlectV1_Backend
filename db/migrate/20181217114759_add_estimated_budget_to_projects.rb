# frozen_string_literal: true

class AddEstimatedBudgetToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :est_budget, :decimal, default: nil
  end
end
