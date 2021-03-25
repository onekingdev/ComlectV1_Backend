# frozen_string_literal: true

class AddInfoDotToTurnkeySolutions < ActiveRecord::Migration
  def change
    add_column :turnkey_solutions, :info_dot, :string
  end
end
