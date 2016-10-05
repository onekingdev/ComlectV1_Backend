# frozen_string_literal: true
class AddStatusDetailToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :status_detail, :string
  end
end
