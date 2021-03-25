# frozen_string_literal: true

class AddCreditsToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :credits_in_cents, :integer, default: 0
  end
end
