# frozen_string_literal: true

class AddFeeFreeToBusiness < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :fee_free, :boolean, default: false
  end
end
