# frozen_string_literal: true

class ChangeEstHoursTurnkeys < ActiveRecord::Migration
  def change
    remove_column :turnkey_solutions, :hours
    add_column :turnkey_solutions, :hours, :boolean, default: false
  end
end
