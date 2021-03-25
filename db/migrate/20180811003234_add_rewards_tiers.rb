# frozen_string_literal: true

class AddRewardsTiers < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards_tiers do |t|
      t.string :name, null: false
      t.decimal :fee_percentage, precision: 2, scale: 2, null: false
      t.int4range :amount, null: false
      t.timestamps
    end
  end
end
