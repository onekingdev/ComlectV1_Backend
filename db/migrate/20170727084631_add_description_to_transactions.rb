# frozen_string_literal: true

class AddDescriptionToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :description, :text
  end
end
