# frozen_string_literal: true

class CreateReferralTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :referral_tokens do |t|
      t.integer :referrals_count, null: false, default: 0
      t.integer :amount_in_cents, null: false
      t.string :token, null: false
      t.integer :referrer_id, null: false
      t.string :referrer_type, null: false
      t.timestamps
    end

    add_index :referral_tokens, :token, unique: true
    add_index :referral_tokens, %i[referrer_id referrer_type]
  end
end
