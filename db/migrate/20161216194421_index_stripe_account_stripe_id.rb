# frozen_string_literal: true

class IndexStripeAccountStripeId < ActiveRecord::Migration[6.0]
  def change
    add_index :stripe_accounts, :stripe_id
  end
end
