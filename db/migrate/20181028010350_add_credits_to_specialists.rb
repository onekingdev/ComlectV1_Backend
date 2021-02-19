# frozen_string_literal: true

class AddCreditsToSpecialists < ActiveRecord::Migration
  def change
    add_column :specialists, :credits_in_cents, :integer, default: 0
  end
end
