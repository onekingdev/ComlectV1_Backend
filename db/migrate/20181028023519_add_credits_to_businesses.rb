# frozen_string_literal: true

class AddCreditsToBusinesses < ActiveRecord::Migration[6.0]
  def change
    add_column :businesses, :credits_in_cents, :integer, default: 0
  end
end
