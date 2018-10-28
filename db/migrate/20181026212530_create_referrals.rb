# frozen_string_literal: true

class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.integer :referral_token_id, null: false
      t.integer :referrable_id, null: false
      t.string :referrable_type, null: false
      t.timestamps
    end

    add_index :referrals, %i[referrable_id referrable_type], unique: true
  end
end
