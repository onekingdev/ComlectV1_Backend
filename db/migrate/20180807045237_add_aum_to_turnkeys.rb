# frozen_string_literal: true

class AddAumToTurnkeys < ActiveRecord::Migration
  def change
    add_column :turnkey_solutions, :aum, :boolean
  end
end
