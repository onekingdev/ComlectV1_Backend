# frozen_string_literal: true

class IndexStripeAccountStripeId < ActiveRecord::Migration
  def change
    add_index :stripe_accounts, :stripe_id
  end
end
