# frozen_string_literal: true

class AddFeeFreeToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :fee_free, :boolean, default: false
  end
end
