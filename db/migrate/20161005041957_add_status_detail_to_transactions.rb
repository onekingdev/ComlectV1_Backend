# frozen_string_literal: true

class AddStatusDetailToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :status_detail, :string
  end
end
