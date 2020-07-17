# frozen_string_literal: true

class AddAutomatchingAvailableToSpecialists < ActiveRecord::Migration
  def change
    add_column :specialists, :automatching_available, :boolean, default: false
  end
end
