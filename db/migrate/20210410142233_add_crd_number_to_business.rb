# frozen_string_literal: true

class AddCrdNumberToBusiness < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :crd_number, :string
    add_column :businesses, :account_created, :boolean, default: false
    add_column :businesses, :apartment, :string
  end
end
