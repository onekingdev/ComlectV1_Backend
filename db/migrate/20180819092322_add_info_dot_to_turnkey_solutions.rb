# frozen_string_literal: true

class AddInfoDotToTurnkeySolutions < ActiveRecord::Migration[6.0]
  def change
    add_column :turnkey_solutions, :info_dot, :string
  end
end
