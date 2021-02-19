# frozen_string_literal: true

class AddDescriptionToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :description, :text
  end
end
