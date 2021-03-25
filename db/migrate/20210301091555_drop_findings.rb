# frozen_string_literal: true

class DropFindings < ActiveRecord::Migration[6.0]
  def change
    drop_table :findings
  end
end
